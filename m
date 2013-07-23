Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3GWBDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:03:09 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:33124 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3GWBC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:02:59 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At1pACfW7VFV5qu1PGdsb2JhbABbgwODJoUjuGcEAYEVFwMBAQEBODWCJAEBBTocIxAIAxQECRQRDwUlChoBEogUuGIWjmOBHQeDEG4Dl1yGM44vOg
X-IronPort-AV: E=Sophos;i="4.89,723,1367964000"; 
   d="scan'208";a="288764559"
From: rydberg@euromail.se
Date: Tue, 23 Jul 2013 03:04:37 +0200
To: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Message-ID: <20130723010437.GA570@polaris.bitmath.org>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond, Linus,

On Sun, Jul 21, 2013 at 12:53:10PM -0700, Linus Torvalds wrote:
> So it's been another week, and -rc2 is out there.

This one happens to break nfs in a rather blunt-instrument fashion -
creating files on a nfs4 partition [1] no longer works. Bisection
yields this commit as the culprit:

commit b4a2cf76ab7c08628c62b2062dacefa496b59dfd
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed Jul 17 16:43:16 2013 -0400

    NFSv4: Fix a regression against the FreeBSD server
    
    Technically, the Linux client is allowed by the NFSv4 spec to send
    3 word bitmaps as part of an OPEN request. However, this causes the
    current FreeBSD server to return NFS4ERR_ATTRNOTSUPP errors.
    
    Fix the regression by making the Linux client use a 2 word bitmap unless
    doing NFSv4.2 with labeled NFS.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Reverting the patch returns things to normal.

Thanks,
Henrik

[1] type nfs4 (rw,relatime,vers=4.0,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=sys,clientaddr=192.168.0.10,local_lock=none,addr=192.168.0.142)
