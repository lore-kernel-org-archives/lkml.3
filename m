Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab3GHQy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:54:27 -0400
Received: from [216.240.18.76] ([216.240.18.76]:30171 "EHLO mx11.netapp.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3GHQyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:54:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,1021,1363158000"; 
   d="scan'208";a="32448870"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Waiman Long <Waiman.Long@hp.com>, Jeff Layton <jlayton@redhat.com>,
        "Miklos Szeredi" <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v3 24/25] sunrpc: Change how dentry's d_lock field is
 accessed
Thread-Topic: [PATCH v3 24/25] sunrpc: Change how dentry's d_lock field is
 accessed
Thread-Index: AQHOeCuDxj1Mkxx6v0SrzBwmCw+D3plUYKkAgAcbxwA=
Date: Mon, 8 Jul 2013 16:53:52 +0000
Message-ID: <1373302428.2231.9.camel@leira.trondhjem.org>
References: <1372883132-23410-1-git-send-email-Waiman.Long@hp.com>
	 <20130704042034.GM4165@ZenIV.linux.org.uk>
In-Reply-To: <20130704042034.GM4165@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <80EDF0303559BA419A6FC4A793CD17AD@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r68GsVuD006034

On Thu, 2013-07-04 at 05:20 +0100, Al Viro wrote:
> On Wed, Jul 03, 2013 at 04:25:32PM -0400, Waiman Long wrote:
> > There is no change in logic and everything should just work.
> 
> > -		spin_lock(&file->f_path.dentry->d_lock);
> > +		d_lock(file->f_path.dentry);
> >  		if (!d_unhashed(file->f_path.dentry))
> >  			clnt = RPC_I(inode)->private;
> >  		if (clnt != NULL && atomic_inc_not_zero(&clnt->cl_count)) {
> > -			spin_unlock(&file->f_path.dentry->d_lock);
> > +			d_unlock(file->f_path.dentry);
> 
> Could somebody explain WTF is being protected here?  It's not ->private -
> that gets set (and, more importantly, cleared) without ->d_lock in sight.
> Trond, that seems to be your code from about three years ago (introduced
> in "SUNRPC: Fix a race in rpc_info_open").  What's going on there?

AFAICR we're using the fact that the dentry will remain hashed until
we're in the process of freeing up the rpc_client. By testing that the
dentry is hashed under the dentry->d_lock, we are assured that the
non-NULL 'clnt' is still pointing to a valid rpc_client, and that it is
safe to access clnt->cl_count.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
