Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3KNGwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 01:52:25 -0500
Received: from imap.thunk.org ([74.207.234.97]:58397 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab3KNGwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 01:52:19 -0500
Date: Thu, 14 Nov 2013 01:52:12 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: /dev/random changes for 3.13
Message-ID: <20131114065212.GA13618@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20131114020332.GA10961@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
In-Reply-To: <20131114020332.GA10961@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On Wed, Nov 13, 2013 at 09:03:32PM -0500, Theodore Ts'o wrote:
> The following changes since commit 6e4664525b1db28f8c4e1130957f70a94c19213e:
> 
>   Linux 3.11 (2013-09-02 13:46:10 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git tags/random_for_linus
> 
> for you to fetch changes up to 392a546dc8368d1745f9891ef3f8f7c380de8650:
> 
>   random: add debugging code to detect early use of get_random_bytes() (2013-11-03 18:24:08 -0500)

There will be a merge conflict thanks to changes from the net tree.
Here is the proposed resolution:

commit 6b284fe1892e320a76145bdc421fc7222169c98b
Merge: 392a546 2821fe6
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Nov 13 20:27:49 2013 -0500

    Merge /usr/projects/linux/base into merge-resolve
    
    Conflicts:
    	drivers/char/random.c

diff --cc drivers/char/random.c
index cdf4cfb,4fe5609..aa051ef
- --- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@@ -654,14 -601,12 +654,16 @@@ retry
  	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
  		goto retry;
  
- - 	r->entropy_total += nbits;
  	if (!r->initialized && nbits > 0) {
+ 		r->entropy_total += nbits;
  		if (r->entropy_total > 128) {
- - 			if (r == &nonblocking_pool)
- - 				pr_notice("random: %s pool is initialized\n",
- - 					  r->name);
  			r->initialized = 1;
 -			if (r == &nonblocking_pool)
 +			r->entropy_total = 0;
++			if (r == &nonblocking_pool) {
+ 				prandom_reseed_late();
++				pr_notice("random: %s pool is initialized\n",
++					  r->name);
++			}
  		}
  	}
  

I've pushed this merge resolution here:

http://git.kernel.org/cgit/linux/kernel/git/tytso/random.git/log/?h=trial_merge

git pull git://git.kernel.org/pub/scm/linux/kernel/git/tytso/random.git trial_merge

% git show-ref trial_merge
c0caa5d6dd21f115005a73311960d60172028047 refs/heads/trial_merge

Cheers,

							- Ted
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCAAGBQJShHMcAAoJENNvdpvBGATwiLQP/2+zj0iAwkae2WCHgKEd5g0G
8iHzzQ23JJChoItJE/8OWs3HnsdiJsz+dTpe05ZFIfRWO0p3Niyrstr6Jc9Wk0eL
p9tA/VNGuCwOcqpTaKLNs3mSUlS6IgIDs2UoFnbAjzG5lddsPTfOuWRyqCpYWNWI
5Q1bz/zobvUcgVmNL/Crv5DHut4vyMH40O9LJZIREDwAXp8X6XzqNHNcbiESqgRg
K7MRD3mzX1Xojs07SIszmKEGoXhDxmWAbpLf3ulv3qS/FI7hPevUqqj4NWjnFppJ
iNFOcRCLfQpXBA3y+b2sj+EpLwG32WhX0fs4oT8cX4wpqEmymqAxM1Ek/+ZdZmkB
Aw9JX20JPQ4U8tdlQgSvZfg/B/gDFcysV2mTgjuME23qqZLRLfmWpwUrE8lpVolC
ZxRt4ouE7y5/gjUg1KM4ASLZzwYnSsnyLuWk6WGtF1YQcaAeTYjZEWJqAL3fuJdI
5JpDYO7givH9Sv6cFPnuoKVfZyQrQPkkshxBLBO1Vlhb2zxgRNmYGqMdAnnog7NG
4VF9j3WoG7NwynXy5iZyedpO8dF2HfL+Bk2hoepVyqiY/L36hciyjA+yAOpUDePq
QpcUqe7/YEucqvgPxHpy2UIR3w/LSkFGoLU3tqdF5bR95tSuU+XEEp5mZcBWPdA4
fHRXvUWN+eQya2PdWnoE
=IkXd
-----END PGP SIGNATURE-----
