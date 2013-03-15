Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3COSTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:19:09 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:39093 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3COSTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <87ehfhtftn.fsf@rustcorp.com.au>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net>
 <87ehfhtftn.fsf@rustcorp.com.au>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Mar 2013 11:18:46 -0700
Message-ID: <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Allow optional module parameters
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:03 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>> Current parameter behavior is odd.  Boot parameters that have values
>> and don't match anything become environment variables, with no
>> warning.  Boot parameters without values that don't match anything
>> go into argv_init.  Everything goes into /proc/cmdline.
>>
>> The init_module and finit_module syscalls, however, are strict:
>> parameters that don't match result in -ENOENT.
>>
>> kmod (and hence modprobe), when loading a module called foo, look in
>> /proc/cmdline for foo.x or foo.x=y, strip off the foo., and pass the
>> rest to init_module.
>>
>> The upshot is that booting with module.nonexistent_parameter=1 is
>> okay if module is built in or missing entirely but prevents module
>> from loading if it's an actual module.  Similarly, option module
>> nonexistent_parameter=1 in /etc/modprobe.d prevents the module from
>> loading the parameter goes away.  This means that removing module
>> parameters unnecessarily breaks things.
>
> Err, yes.  Don't remove module parameters, they're part of the API.  Do
> you have a particular example?

So things like i915.i915_enable_ppgtt, which is there to enable
something experimental, needs to stay forever once the relevant
feature becomes non-experimental and non-optional?  This seems silly.
Having the module parameter go away while still allowing the module to
load seems like a good solution (possibly with a warning in the logs
so the user can eventually delete the parameter).

In any case, I find it odd that the only parameters you can set that
cause errors when the parameter is deleted are parameters for modules
that are built as modules.

>
>> With this patch, module parameters can be made explicitly optional.
>> This approach is IMO silly, but it's unlikely to break anything,
>> since I doubt that anyone needs init parameters or init environment
>> variables that end in a tilde.
>
> It's silly for the removal problem: that should be handled in the
> kernel.  How would the poor user know that the option is going away?
> So how about we add a module_param_obsolete(name) macro?
>
> If a parameter were introduced, and the user wanted to specify it *if*
> it was supported, that might justify this approach rather than using
> complex install commands.  But I don't believe that's common, is it?
>

It's happened multiple times to me with things like
pcie_aspm.force_aspm and i915.whatever.

--Andy
