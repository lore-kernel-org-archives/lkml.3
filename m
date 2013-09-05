Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3IEO00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:26:26 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49004 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab3IEO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:26:24 -0400
Date: Thu, 5 Sep 2013 16:26:51 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 04/11] vfs: check unlinked ancestors before mount
Message-ID: <20130905142651.GB25538@tucsk.piliscsaba.szeredi.hu>
References: <1378374284-1484-1-git-send-email-miklos@szeredi.hu>
 <1378374284-1484-5-git-send-email-miklos@szeredi.hu>
 <20130905111852.GP13318@ZenIV.linux.org.uk>
 <CAJfpeguzpkw3SYm6kBP-acLSHTgYLXMFRZDf2T0U4aowYhfQdA@mail.gmail.com>
 <20130905120230.GA21170@tucsk.piliscsaba.szeredi.hu>
 <CAJfpegtXQebPEQqw8ESmM-Bp0QgCefmRwoNeJNtN-_bV35b-pw@mail.gmail.com>
 <20130905123911.GA25538@tucsk.piliscsaba.szeredi.hu>
 <20130905132325.GQ13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905132325.GQ13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 02:23:25PM +0100, Al Viro wrote:
> On Thu, Sep 05, 2013 at 02:39:11PM +0200, Miklos Szeredi wrote:
> > +static bool __has_unlinked_ancestor(struct dentry *dentry)
> > +{
> > +	struct dentry *this;
> > +
> > +	for (this = dentry; !IS_ROOT(this); this = this->d_parent) {
> > +		int is_unhashed;
> > +
> > +		/* Need exclusion wrt. check_submounts_and_drop() */
> > +		spin_lock(&this->d_lock);
> > +		is_unhashed = d_unhashed(this);
> > +		spin_unlock(&this->d_lock);
> > +
> > +		if (is_unhashed)
> > +			return true;
> > +	}
> > +	return false;
> > +}
> 
> I still don't get it; why do you need to bother with early setting of
> DCACHE_MOUNTED?
> 
> You are grabbing rename_lock for write in d_set_mounted().  What kind of races
> with check for submounts are you worried about?  d_walk() will rescan
> everything if something grabs rename_lock for write while it had been running,
> so just fold the "have nothing in d_subdir" case of check_submounts_and_drop()
> into d_walk() and be done with that...  What's the problem with such
> variant?  AFAICS, all you need to care about is d_set_mounted() not getting
> between the scan for submounts and actual __d_drop() and your "finish"
> callback is called only after d_walk() having grabbed d_lock *and* rechecked
> rename_lock.

Okay, I get it.  So this should work:

int d_set_mounted(struct dentry *dentry)
{
	int ret = -ENOENT;

	write_seqlock(&rename_lock);
	if (!__has_unlinked_ancestor(dentry->d_parent)) {
		spin_lock(&dentry->d_lock);
		if (!d_unlinked(dentry)) {
			dentry->d_flags |= DCACHE_MOUNTED;
			ret = 0;
		}
		spin_unlock(&dentry->d_lock);
	}
	write_sequnlock(&rename_lock);
	return ret;
}

The __has_unlinked_ancestor(dentry->d_parent) will work if dentry is a root, but
maybe it would be clearer to add that IS_ROOT explicitly?

Thanks,
Miklos


