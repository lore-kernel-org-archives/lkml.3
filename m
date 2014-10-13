Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaJMJQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:16:41 -0400
Received: from ppsw-40.csi.cam.ac.uk ([131.111.8.140]:40238 "EHLO
	ppsw-40.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaJMJQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:16:40 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: WTF is d_add_ci() doing with negative dentries?
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20141013021459.GW7996@ZenIV.linux.org.uk>
Date: Mon, 13 Oct 2014 10:16:16 +0100
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <80914ACA-9F62-42DA-820D-FE0F297B3075@cam.ac.uk>
References: <20141012221817.GU7996@ZenIV.linux.org.uk> <318CCEE2-9EBE-4696-8DE9-7297CDCE207D@cam.ac.uk> <20141013021459.GW7996@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 13 Oct 2014, at 03:14, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Mon, Oct 13, 2014 at 12:56:11AM +0100, Anton Altaparmakov wrote:
>> I am just wondering whether there might be error conditions in which we might end up with a (perhaps invalid) negative dentry in memory which could be found here?  Probably not a problem especially now that d_invalidate() cannot fail any more.
> 
> Huh?  Failing d_invalidate() on _negative_ dentry is flat-out impossible;
> it would be dropped just fine, and we wouldn't have found it in the first
> place.  Check what it used to do all way back to 2.2.0:
>        if (dentry->d_count) {
>                if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode))
>                        return -EBUSY;
>        }
> 
> So unless you care about 2.1.something (2.0 didn't have dcache at all),
> this scenario isn't possible.

That's fine then.  And no I don't care about 2.1.  I start caring at 2.6.15 at the moment.

> In any case, d_add_ci() users that might have negative dentries become
> positive cannot afford hashed negative dentries at all - at the very
> least they need to treat them as invalid in ->d_revalidate() in such
> situations.

Yes, that is what I do.  I have my own d_revalidate method which reports all negative dentries as invalid any time a new name is added in the parent directory.  In fact I set d_time of each dentry to i_version of the parent directory inode and on each "add name to directory" I bump i_version of the parent directory and d_revalidate checks d_time against d_parent->d_inode->i_version and if not equal the negative dentry is considered invalid and that seems to work fine (I ignore d_time on positive dentries in d_revalidate).

> Exactly because having a hashed valid negative dentry for
> FuBaR after e.g.  mkdir fubar will really hurt - mkdir won't have any way
> to know that old dentry was there; there was no variant of fubar in directory
> prior to that mkdir (FuBaR _was_ negative) and there's nothing to suggest
> looking for it.  So it won't be noticed and it'll bloody well stay negative
> and hashed.  I.e. stat FuBaR; mkdir fubar; stat FuBaR will have the second
> stat find dentry still hashed and valid negative.
> 
> You can get away with that if you store something like timestamp[1] of
> the parent directory in those negative dentries and check that in
> ->d_revalidate().  But that will work just fine, since d_add_ci() is
> serialized by ->i_mutex held on parent and whatever it was that added your
> "exact spelling" into directory has made all preexisting negative dentries
> invalid...

Yes, that is basically what I do except I use i_version on the parent rather than its d_time and I don't set d_time to zero (I always set it to i_version of parent instead though I doubt it matters in the slightest - I could equally not be setting it at all for positive dentries given I never check it for them).

Best regards,

	Anton

> [1] for arbitrary values of time - e.g.
> 	on positive lookup set ->d_time to 0
> 	on negative lookup set ->d_time to that of parent dentry
> 	on mkdir set ->d_time to 0
> 	on unlink, rmdir and rename victim copy ->d_time from parent dentry
> 	on any directory modification bump its ->d_time
> 	on d_revalidate of negative dentry compare ->d_time with that of parent
> 	dentry and declare invalid on mismatch
> will do just fine.

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
University of Cambridge Information Services, Roger Needham Building
7 JJ Thomson Avenue, Cambridge, CB3 0RB, UK

