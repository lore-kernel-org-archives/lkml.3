Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbbAUVbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:31:05 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:46880 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbbAUVbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:31:01 -0500
Date: Wed, 21 Jan 2015 22:30:55 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>, Paul Moore <pmoore@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121213055.GA7786@kria>
References: <54BF1292.2080902@roeck-us.net>
 <20150121033600.GN29656@ZenIV.linux.org.uk>
 <54BF2496.4000807@roeck-us.net>
 <20150121043637.GO29656@ZenIV.linux.org.uk>
 <20150121110539.GA8924@kria>
 <54BFAA5D.4040108@roeck-us.net>
 <20150121182905.GQ29656@ZenIV.linux.org.uk>
 <54BFF8B3.6060802@roeck-us.net>
 <20150121200626.GR29656@ZenIV.linux.org.uk>
 <54C01418.5060204@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54C01418.5060204@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-21, 13:03:20 -0800, Guenter Roeck wrote:
> On 01/21/2015 12:06 PM, Al Viro wrote:
> >On Wed, Jan 21, 2015 at 11:06:27AM -0800, Guenter Roeck wrote:
> >>On 01/21/2015 10:29 AM, Al Viro wrote:
> >>>On Wed, Jan 21, 2015 at 05:32:13AM -0800, Guenter Roeck wrote:
> >>>>Another data point (though I have no idea if it is useful or what it means):
> >>>>
> >>>>In the working case, path_init sets nd->flags to 0x50 or 0x51.
> >>>>In the non-working case (ie for all files with a '/' in the name),
> >>>>it sets nd->flags to 0x10 or 0x11, even though it is always called
> >>>>with the LOOKUP_RCU bit set in flags.
> >>>
> >>>Umm...  Are those path_init() succeeding or failing?  Note that path_init()
> >>>includes "walk everything except for the last component", so your non-working
> >>>case is "have it walk anything at all".  What's failing there?  path_init()
> >>>or handling the remaining component?
> >>>
> >>path_init() returns -2. Guess that explains the unexpected flags ;-).
> >>The failuere is from
> >>	link_path_walk()
> >>		walk_component()
> >
> >Which is to say, lookup gave it a negative dentry.  OK, let's just make
> >vfs_mkdir() and walk_component() print what they are doing; on top of
> >linux-next
> >
> >diff --git a/fs/namei.c b/fs/namei.c
> >index 323957f..8a4e22f 100644
> >--- a/fs/namei.c
> >+++ b/fs/namei.c
> >@@ -1586,8 +1586,11 @@ static inline int walk_component(struct nameidata *nd, struct path *path,
> >  		inode = path->dentry->d_inode;
> >  	}
> >  	err = -ENOENT;
> >-	if (!inode || d_is_negative(path->dentry))
> >+	if (!inode || d_is_negative(path->dentry)) {
> >+		printk(KERN_ERR "walk_component[%p,%pd4] -> negative\n",
> >+			path->dentry, path->dentry);
> >  		goto out_path_put;
> >+	}
> >
> >  	if (should_follow_link(path->dentry, follow)) {
> >  		if (nd->flags & LOOKUP_RCU) {
> >@@ -3521,6 +3524,7 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
> >  	error = dir->i_op->mkdir(dir, dentry, mode);
> >  	if (!error)
> >  		fsnotify_mkdir(dir, dentry);
> >+	printk(KERN_ERR "mkdir[%p,%pd4] => %d\n", dentry, dentry, error);
> >  	return error;
> >  }
> >  EXPORT_SYMBOL(vfs_mkdir);
> >
> 
> ok case (putname commented out):
> 
> user_path_at_empty lookup usr flags 0x0
> path_lookupat: calling path_init 'usr' flags=40
> path_init: link_path_walk() returned 0
> path_lookupat: path_init 'usr' flags=40[50] returned 0
> walk_component: lookup_fast() returned 1
> walk_component: lookup_slow() returned 0
> walk_component: inode=  (null), negative=1
> do_path_lookup(usr, 0x10)
> path_lookupat: calling path_init 'usr' flags=50
> path_init: link_path_walk() returned 0
> path_lookupat: path_init 'usr' flags=50[50] returned 0
> mkdir[c74012a0,/usr] => 0
> user_path_at_empty lookup usr flags 0x1
> path_lookupat: calling path_init 'usr' flags=41
> path_init: link_path_walk() returned 0
> path_lookupat: path_init 'usr' flags=41[51] returned 0
> walk_component: inode=c74004a0, negative=0
> user_path_at_empty lookup usr flags 0x1
> path_lookupat: calling path_init 'usr' flags=41
> path_init: link_path_walk() returned 0
> path_lookupat: path_init 'usr' flags=41[51] returned 0
> 
> failing case:
> 
> path_lookupat: calling path_init 'usr' flags=40
> path_init: link_path_walk() returned 0
> path_lookupat: path_init 'usr' flags=40[50] returned 0
> walk_component: lookup_fast() returned 1
> walk_component: lookup_slow() returned 0
> walk_component: inode=  (null), negative=1
> do_path_lookup(usr, 0x10)
> path_lookupat: calling path_init 'usr' flags=50
> path_init: link_path_walk() returned 0
> path_lookupat: path_init 'usr' flags=50[50] returned 0
> mkdir[c74012a0,/kkk] => 0						<==== SIC!
> user_path_at_empty lookup usr flags 0x1
> path_lookupat: calling path_init 'usr' flags=41
> path_init: link_path_walk() returned 0
> path_lookupat: path_init 'usr' flags=41[51] returned 0
> walk_component: lookup_fast() returned 1
> walk_component: lookup_slow() returned 0
> walk_component: inode=  (null), negative=1
> user_path_at_empty lookup usr flags 0x1
> path_lookupat: calling path_init 'usr' flags=41
> path_init: link_path_walk() returned 0
> path_lookupat: path_init 'usr' flags=41[51] returned 0
> walk_component: lookup_fast() returned 1
> walk_component: lookup_slow() returned 0
> walk_component: inode=  (null), negative=1

Yep, I get some "kkk" too.

With that patch:

## panic

[    0.544839] walk_component[ffff88001d6edbd8,/dev] -> negative
[    0.545507] mkdir[ffff88001d6ed1b8,/kkk] => 0
[    0.545886] sys_mkdir dev:40755 returned 0
[    0.546275] walk_component[ffff88001d6ec288,/dev] -> negative
[    0.546835] walk_component[ffff88001d6eca20,/dev] -> negative
[    0.547403] walk_component[ffff88001d6ed950,/dev] -> negative
[    0.547954] walk_component[ffff88001d6ed440,/dev] -> negative
[    0.549260] walk_component[ffff88001d6ec510,/dev] -> negative
[    0.551161] walk_component[ffff88001d6ec798,/dev] -> negative
[    0.551719] walk_component[ffff88001d6ed6c8,/dev] -> negative
[    0.552281] walk_component[ffff88001d6eef30,/root] -> negative
[    0.552866] mkdir[ffff88001d6ee000,/kkkk] => 0
[    0.553254] sys_mkdir root:40700 returned 0
[    0.553682] walk_component[ffff88001d6eeca8,/root] -> negative
[    0.554225] walk_component[ffff88001d6efbd8,/root] -> negative
[    0.554826] walk_component[ffff88001d6ef1b8,/root] -> negative
[    0.555390] walk_component[ffff88001d6ee288,/dev] -> negative
[    0.561523] walk_component[ffff88001d6eea20,/cpu] -> negative
[    0.562203] mkdir[ffff88001d6ef950,/kkk] => 0
[    0.562627] walk_component[ffff88001d6ef440,/cpu] -> negative
[    0.819060] walk_component[ffff88001d6df1b8,/input] -> negative
[    0.819672] mkdir[ffff88001d6def30,/kkkkk] => 0
[    0.820496] walk_component[ffff88001d6de510,/input] -> negative
[    0.840538] walk_component[ffff88001d6e6288,/dev] -> negative
[    0.841626] walk_component[ffff88001d6e6f30,/init] -> negative
[    0.992725] walk_component[ffff88001d6e6f30,/bsg] -> negative
[    0.993671] mkdir[ffff88001d6e6798,/kkk] => 0
[    0.994307] walk_component[ffff88001d6e6288,/bsg] -> negative
[    1.007701] walk_component[ffff88001d6e6ca8,/bsg] -> negative
[    1.008561] walk_component[ffff88001d6e7950,/bsg] -> negative
[    1.024292] walk_component[ffff88001d6e7950,/dev] -> negative
[    1.025017] walk_component[ffff88001d6e7440,/dev] -> negative
[    1.025781] walk_component[ffff88001d6e6f30,/dev] -> negative
[    1.026495] walk_component[ffff88001d6e6510,/dev] -> negative
[    1.027243] walk_component[ffff88001d6e6288,/dev] -> negative
[    1.027910] stat("/dev/root") -> -2
[    1.028358] walk_component[ffff88001d6df6c8,/dev] -> negative
[    1.029019] stat("dev") -> -2
[    1.029431] walk_component[ffff88001d6df1b8,/root] -> negative

## good

[    0.350197] walk_component[ffff88001e348c80,/dev] -> negative
[    0.350821] mkdir[ffff88001e348dc0,/dev] => 0
[    0.351467] sys_mkdir dev:40755 returned 0
[    0.351919] walk_component[ffff88001e349000,/dev/console] -> negative
[    0.353000] walk_component[ffff88001e349280,/root] -> negative
[    0.353959] mkdir[ffff88001e3493c0,/root] => 0
[    0.354354] sys_mkdir root:40700 returned 0
[    0.357927] walk_component[ffff88001e349500,/cpu] -> negative
[    0.358470] mkdir[ffff88001e349640,/cpu] => 0
[    0.472772] walk_component[ffff88001e34ba00,/input] -> negative
[    0.473392] mkdir[ffff88001e34bb40,/input] => 0
[    0.478682] walk_component[ffff88001e34cdc0,/init] -> negative
[    0.647559] walk_component[ffff88001e34cdc0,/bsg] -> negative
[    0.648671] mkdir[ffff88001e34ba00,/bsg] => 0
[    0.665831] stat("/dev/root") -> 0
[    0.666360] stat("dev") -> 0


Another thing, not sure if it's relevant: I can boot with the
do_lookup_path patch applied, and without commenting out putname(), if
I disable SLUB debugging with slub_debug=- (with CONFIG_SLUB_DEBUG=y
CONFIG_SLUB_DEBUG_ON=y)



-- 
Sabrina
