Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab3JWC4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:56:22 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:59931 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3JWC4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:56:20 -0400
MIME-Version: 1.0
In-Reply-To: <20131003213625.GH5729@outflux.net>
References: <20130920203556.GA8726@www.outflux.net> <alpine.LRH.2.02.1309241124420.3782@tundra.namei.org>
 <alpine.LRH.2.02.1309241128430.3782@tundra.namei.org> <CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com>
 <20131003205515.GF5729@outflux.net> <201310040631.IIF39022.OVFOFQOtJSFHLM@I-love.SAKURA.ne.jp>
 <20131003213625.GH5729@outflux.net>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 23 Oct 2013 00:55:59 -0200
Message-ID: <CAKi4VAJTEu=k760=Z0GWCwGGr4USnXbMSrwnEV99sQg8LFhpxg@mail.gmail.com>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
To: Kees Cook <kees@outflux.net>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>, jmorris@namei.org,
        lkml <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

On Thu, Oct 3, 2013 at 6:36 PM, Kees Cook <kees@outflux.net> wrote:
> On Fri, Oct 04, 2013 at 06:31:42AM +0900, Tetsuo Handa wrote:
>> Kees Cook wrote:
>> > +static int modpin_load_module(struct file *file)
>> > +{
>> > +   struct dentry *module_root;
>> > +
>> > +   if (!file) {
>> > +           if (!modpin_enforced) {
>> > +                   report_load_module(NULL, "old-api-pinning-ignored");
>> > +                   return 0;
>> > +           }
>> > +
>> > +           report_load_module(NULL, "old-api-denied");
>> > +           return -EPERM;
>> > +   }
>> > +
>> > +   module_root = file->f_path.mnt->mnt_root;
>> > +
>> > +   /* First loaded module defines the root for all others. */
>> > +   spin_lock(&pinned_root_spinlock);
>> > +   if (!pinned_root) {
>> > +           pinned_root = dget(module_root);
>> > +           /*
>> > +            * Unlock now since it's only pinned_root we care about.
>> > +            * In the worst case, we will (correctly) report pinning
>> > +            * failures before we have announced that pinning is
>> > +            * enabled. This would be purely cosmetic.
>> > +            */
>> > +           spin_unlock(&pinned_root_spinlock);
>> > +           check_pinning_enforcement();
>> > +           report_load_module(&file->f_path, "pinned");
>> > +           return 0;
>> > +   }
>> > +   spin_unlock(&pinned_root_spinlock);
>>
>> Firstly loaded module is usually in initramfs whereas subsequently loaded
>> modules are usually on a hard disk partition.
>>
>> This module is not meant for PC servers, is it?
>
> This LSM is what Chrome OS uses for the module pinning logic. We do not use
> an initramfs. This LSM could also be used for devices booting entirely from
> CDROM or other R/O media.
>
> I'm open to improvements, obviously. I imagine things like delayed
> activation, where the initramfs triggers pinning in some way once it is
> done loading modules from its filesystem, etc. But since I don't have any
> real life examples of this, I'm writing the LSM as it currently is, used
> without an initramfs. :)

The way you put now as well as the code are at least different from
what it's written in the commit message.  I was expecting that this
modpin would allow module loading only from a trusted partition.
Instead we are allowing to load modules from the same partition of the
first module that has been loaded, if the root is trusted. Why? What's
the relation with the root partition being trusted and the partition
where the modules reside?  What's the guarantee that the first module
to load is any more trustable than the others?

Lucas De Marchi
