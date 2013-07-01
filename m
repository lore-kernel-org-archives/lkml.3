Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3GAQdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:33:21 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:57778 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3GAQdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:33:19 -0400
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Re: [RFC PATCH] Allow optional module parameters
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net> <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com> <87sj3tsawh.fsf@rustcorp.com.au> <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com> <87hak8qfu5.fsf@rustcorp.com.au> <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com> <87sj3qpwdz.fsf@rustcorp.com.au> <87a9m6sri3.fsf@rustcorp.com.au>
From: Jonathan Masters <jcm@redhat.com>
MIME-Version: 1.0
In-Reply-To: <87a9m6sri3.fsf@rustcorp.com.au>
Message-Id: <9F26321B-7088-4D16-80D5-72EB388F8E49@redhat.com>
Date: Mon, 1 Jul 2013 12:33:11 -0400 (EDT)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
X-Mailer: Zimbra 8.0.3_GA_5664 (MobileSync - Apple-iPad2C5/1002.329)
Thread-Topic: Allow optional module parameters
Thread-Index: lVvC5sUGXGoG5aIWIYn4o9qRXo5EpQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One caveat. Sometimes we have manufactured parameters intentionally to cause a module to fail. We should standardize that piece.

-- 
Sent from my iPad

On Jul 1, 2013, at 4:53, Rusty Russell <rusty@rustcorp.com.au> wrote:

> Rusty Russell <rusty@rustcorp.com.au> writes:
>> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>>> Hi Rusty,
>>> 
>>> On Mon, Mar 18, 2013 at 11:32 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>> On Sun, Mar 17, 2013 at 7:24 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>>>> On Thu, Mar 14, 2013 at 10:03 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>>>>>> Err, yes.  Don't remove module parameters, they're part of the API.  Do
>>>>>>>> you have a particular example?
>>>>>>> 
>>>>>>> So things like i915.i915_enable_ppgtt, which is there to enable
>>>>>>> something experimental, needs to stay forever once the relevant
>>>>>>> feature becomes non-experimental and non-optional?  This seems silly.
>>>> ...
>>>>>>> Having the module parameter go away while still allowing the module to
>>>>>>> load seems like a good solution (possibly with a warning in the logs
>>>>>>> so the user can eventually delete the parameter).
>>>>>> 
>>>>>> Why not do that for *every* missing parameter then?  Why have this weird
>>>>>> notation where the user must know that the parameter might one day go
>>>>>> away?
>>>>> 
>>>>> Fair enough.  What about the other approach, then?  Always warn if an
>>>>> option doesn't match (built-in or otherwise) but load the module
>>>>> anyways.
>>>> 
>>>> What does everyone think of this?  Jon, Lucas, does this match your
>>>> experience?
>>>> 
>>>> Thanks,
>>>> Rusty.
>>>> 
>>>> Subject: modules: don't fail to load on unknown parameters.
>>>> 
>>>> Although parameters are supposed to be part of the kernel API, experimental
>>>> parameters are often removed.  In addition, downgrading a kernel might cause
>>>> previously-working modules to fail to load.
>>> 
>>> I agree with this reasoning
>>> 
>>>> 
>>>> On balance, it's probably better to warn, and load the module anyway.
>>> 
>>> However loading the module anyway would bring at least one drawback:
>>> if the user made a typo when passing the option the module would load
>>> anyway and he will probably not even look in the log, since there's
>>> was no errors from modprobe.
> 
> OK, so I've had this patch on the backburner, but noone has come up with
> anything better so I'll queue it into modules-next now.
> 
> Thanks,
> Rusty.
> 
> modules: don't fail to load on unknown parameters.
> 
> Although parameters are supposed to be part of the kernel API, experimental
> parameters are often removed.  In addition, downgrading a kernel might cause
> previously-working modules to fail to load.
> 
> On balance, it's probably better to warn, and load the module anyway.
> This may let through a typo, but at least the logs will show it.
> 
> Reported-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 3c2c72d..46db10a 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3206,6 +3206,17 @@ out:
>    return err;
> }
> 
> +static int unknown_module_param_cb(char *param, char *val, const char *modname)
> +{
> +    /* Check for magic 'dyndbg' arg */ 
> +    int ret = ddebug_dyndbg_module_param_cb(param, val, modname);
> +    if (ret != 0) {
> +        printk(KERN_WARNING "%s: unknown parameter '%s' ignored\n",
> +               modname, param);
> +    }
> +    return 0;
> +}
> +
> /* Allocate and load the module: note that size of section 0 is always
>    zero, and we rely on this for optional sections. */
> static int load_module(struct load_info *info, const char __user *uargs,
> @@ -3292,7 +3303,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
> 
>    /* Module is ready to execute: parsing args may do that. */
>    err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
> -             -32768, 32767, &ddebug_dyndbg_module_param_cb);
> +             -32768, 32767, unknown_module_param_cb);
>    if (err < 0)
>        goto bug_cleanup;
> 
> 
