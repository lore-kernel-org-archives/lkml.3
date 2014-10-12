Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaJLX4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 19:56:39 -0400
Received: from ppsw-40.csi.cam.ac.uk ([131.111.8.140]:54309 "EHLO
	ppsw-40.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaJLX4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 19:56:37 -0400
X-Cam-AntiVirus: found ScamNailer.Phish.viro_AT_zeniv.linux.org.uk
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: WTF is d_add_ci() doing with negative dentries?
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20141012221817.GU7996@ZenIV.linux.org.uk>
Date: Mon, 13 Oct 2014 00:56:11 +0100
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <318CCEE2-9EBE-4696-8DE9-7297CDCE207D@cam.ac.uk>
References: <20141012221817.GU7996@ZenIV.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 12 Oct 2014, at 23:18, Al Viro <viro@zeniv.linux.org.uk> wrote:
> 	AFAICS, if d_add_ci() ever finds a negative hashed dentry for
> exact name, it's already buggered.  Because right *before* that
> d_add_ci() lookup for exact name would've turned valid negative.

Christoph copied d_add_ci() from code I wrote for NTFS so you can blame me for it.  (-;

Do you mean that given the exact name exists on disk, there cannot be a negative dentry for it in memory, i.e. there would either be no dentry in memory or it would be a positive dentry in memory?

If so then that makes sense, yes.

I am just wondering whether there might be error conditions in which we might end up with a (perhaps invalid) negative dentry in memory which could be found here?  Probably not a problem especially now that d_invalidate() cannot fail any more.

Is it worth adding a BUG_ON(!found->d_inode); to ensure sanity/catch bugs?

> IOW, the whole thing ought to be
>        found = d_hash_and_lookup(dentry->d_parent, name);
> 	if (found) {
> 		iput(inode);
> 		return found;
> 	}
> 	new = d_alloc(dentry->d_parent, name);
> 	if (!new) {
> 		iput(inode);
> 		return ERR_PTR(-ENOMEM);
> 	}
> 	found = d_splice_alias(inode, new);
> 	if (found) {
> 		dput(new);
> 		return found;
> 	}
> 	return new;
> Moreover, it might very well be better to pass dentry->d_parent instead
> of dentry...  Objections?

Yes, that bit makes perfect sense given we only ever use dentry->d_parent.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

