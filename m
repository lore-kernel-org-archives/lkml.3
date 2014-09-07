Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaIGH4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 03:56:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaIGH4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 03:56:16 -0400
Date: Sun, 7 Sep 2014 09:56:08 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Piotr Karbowski <piotr.karbowski@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: /proc/<pid>/exe symlink behavior change in >=3.15.
Message-ID: <20140907075607.GA11240@mguzik>
References: <540B8040.5010206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <540B8040.5010206@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2014 at 11:44:32PM +0200, Piotr Karbowski wrote:
> Hi,
> 
> Starting with kernel 3.15 the 'exe' symlink under /proc/<pid>/ acts diffrent
> than it used to in all the pre-3.15 kernels.
> 
> The usecase:
> 
> run /root/testbin (app that just sleeps)
> cp /root/testbin /root/testbin.new
> mv /root/testbin.new /root/testbin
> ls -al /proc/`pidof testbin`/exe
> 
> <=3.14: /root/testbin (deleted)
> >=3.15: /root/testbin.new (deleted)
> 
> Was the change intentional? It does render my system unusable and I failed
> to find a information about such change in the ChangeLog.
> 

It looks like this was already broken for "long" (> DNAME_INLINE_LEN)
names.

Short names share the problem since da1ce0670c14d8 "vfs: add
cross-rename".

The following change to switch_names is the culprit:

-       memcpy(dentry->d_iname, target->d_name.name,
-                   target->d_name.len + 1);
-       dentry->d_name.len = target->d_name.len;
-       return;
+       unsigned int i;
+       BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
+       for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
+     		  swap(((long *) &dentry->d_iname)[i],
+  			((long *) &target->d_iname)[i]);
+       }


Dentries can have names from embedded structure or from an external buffer.

If you take a look around you will see the code just swaps pointers for
"both external" case. But this results in the same behavoiur you are seeing.

Not sure how to fix it. Name in 'target' needs to be preserved, but memory
allocation which may be needed for this purpose can fail and switch_names
returns void, just like its callers (not to mention locks held around this).

One crap idea would be to have external buffers with a reference counter.
d_inode would still be set to the buffer and freeing funcs would use
container_of to get to the counter.

I can implement that later if it sounds sane enough.

Note this behaviour seems to be a requirement for cross-rename to work.

At least restoring previous behaviour while keeping cross-rename is not hard,
I can write it later.

-- 
Mateusz Guzik
