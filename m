Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbbAUP2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:28:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbbAUP2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:28:00 -0500
From: Paul Moore <pmoore@redhat.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Sabrina Dubroca <sd@queasysnail.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount root fs
Date: Wed, 21 Jan 2015 10:24:11 -0500
Message-ID: <9422577.FVVyjQBZjy@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150121144214.GA22884@ulmo.nvidia.com>
References: <20150120165655.GA10904@kria> <20150121110539.GA8924@kria> <20150121144214.GA22884@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 21, 2015 03:42:16 PM Thierry Reding wrote:
> On Wed, Jan 21, 2015 at 12:05:39PM +0100, Sabrina Dubroca wrote:
> > 2015-01-21, 04:36:38 +0000, Al Viro wrote:
> > > On Tue, Jan 20, 2015 at 08:01:26PM -0800, Guenter Roeck wrote:
> > > > With this patch:
> > > > 
> > > > sys_mkdir .:40775 returned -17
> > > > sys_mkdir usr:40775 returned 0
> > > > sys_mkdir usr/lib:40775 returned 0
> > > > sys_mkdir usr/share:40755 returned 0
> > > > sys_mkdir usr/share/udhcpc:40755 returned 0
> > > > sys_mkdir usr/bin:40775 returned 0
> > > > sys_mkdir usr/sbin:40775 returned 0
> > > > sys_mkdir mnt:40775 returned 0
> > > > sys_mkdir proc:40775 returned 0
> > > > sys_mkdir root:40775 returned 0
> > > > sys_mkdir lib:40775 returned 0
> > > > sys_mkdir lib/modules:40775 returned 0
> > > > ...
> > > > 
> > > > and the problem is fixed.
> > 
> > This patch also works for me.
> > 
> > > ... except that it simply confirms that something's fishy with
> > > getname_kernel() of ->name of struct filename returned by getname(). 
> > > IOW, I still do not understand the mechanism of breakage there.
> > 
> > I'm not so sure about that.  I tried to copy name to a new string in
> > do_path_lookup and that didn't help.
> > 
> > Now, I've removed the
> > 
> >         putname(filename);
> > 
> > line from do_path_lookup and I don't get the panic.
> 
> That would indicate that somehow the refcount got unbalanced. Looking
> more closely it seems like the various audit_*() function do take a
> reference, but maybe that's not enough.

I'm thinking the same thing and I think the problem may be that 
__audit_reusename() is not bumping the filename->refcnt.  Can someone who is 
seeing this problem bump the refcnt in __audit_reusename()?

  struct filename *
  __audit_reusename(const __user char *uptr)
  {
        struct audit_context *context = current->audit_context;
        struct audit_names *n;

        list_for_each_entry(n, &context->names_list, list) {
                if (!n->name)
                        continue;
                if (n->name->uptr == uptr) {
+                       n->name->refcnt++;
                        return n->name;
                }
        }
        return NULL;
  }

-- 
paul moore
security @ redhat

