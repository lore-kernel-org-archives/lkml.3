Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3IEO4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:56:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60448 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab3IEO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:56:18 -0400
Date: Thu, 5 Sep 2013 15:56:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 04/11] vfs: check unlinked ancestors before mount
Message-ID: <20130905145613.GR13318@ZenIV.linux.org.uk>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
 <1378374284-1484-5-git-send-email-miklos@szeredi.hu>
 <20130905111852.GP13318@ZenIV.linux.org.uk>
 <CAJfpeguzpkw3SYm6kBP-acLSHTgYLXMFRZDf2T0U4aowYhfQdA@mail.gmail.com>
 <20130905120230.GA21170@tucsk.piliscsaba.szeredi.hu>
 <CAJfpegtXQebPEQqw8ESmM-Bp0QgCefmRwoNeJNtN-_bV35b-pw@mail.gmail.com>
 <20130905123911.GA25538@tucsk.piliscsaba.szeredi.hu>
 <20130905132325.GQ13318@ZenIV.linux.org.uk>
 <20130905142651.GB25538@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905142651.GB25538@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd probably just do this, and to hell with helper functions...

int d_set_mounted(struct dentry *dentry)
{
	struct dentry *p;
	int ret = 0;
	write_seqlock(&rename_lock);
	for (p = dentry; !IS_ROOT(p); p = p->d_parent) {
		/* Need exclusion wrt. check_submounts_and_drop() */
		spin_lock(&p->d_lock);
		if (unlikely(d_unhashed(p))) {
			spin_unlock(&p->d_lock);
			ret = -ENOENT;
			goto out;
		}
		spin_unlock(&p->d_lock);
	}
	spin_lock(&dentry->d_lock);
	dentry->d_flags |= DCACHE_MOUNTED;
 	spin_unlock(&dentry->d_lock);
out:
	write_sequnlock(&rename_lock);
	return ret;
}
