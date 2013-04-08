Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348Ab3DHLz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:55:58 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:45325 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935320Ab3DHLz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:55:56 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.9
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH v1] pwm: add sysfs interface
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, rob@landley.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
From: Lars Poeschel <poeschel@lemonage.de>
Date: Mon, 8 Apr 2013 13:55:47 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304081355.47585.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have to resend the mail, so the kernel list rejected it. I had HTML 
enabled in the MUA by mistake. Sorry for the inconvenience!

Thierry, thank you for this very complete review!

On Monday 08 April 2013 at 10:17:45, Thierry Reding wrote:
> On Wed, Apr 03, 2013 at 03:58:55PM +0200, Lars Poeschel wrote:
> >             /polarity ... r/w, normal(0) or inverse(1) polarity
> >             
> >                                only created if driver supports it
> >             
> >             /run ... r/w, write 1 to start and 0 to stop the pwm
> >         
> >         /pwmchipN ... for each pwmchip; #N is its first PWM
> 
> I think I'd prefer "for each PWM chip", or "for each pwm_chip". No data
> structure named pwmchip exists in the kernel.
> 
> >             /base ... (r/o) same as N
> >             /ngpio ... (r/o) number of PWM; numbered N .. MAX_PWMS
> 
> "npwm"? "number of PWM devices"? MAX_PWMS -> N + (npwm - 1)?

Sorry, npwm and it should be the number of PWM devices.

> > diff --git a/Documentation/ABI/testing/sysfs-class-pwm
> > b/Documentation/ABI/testing/sysfs-class-pwm new file mode 100644
> > index 0000000..e9be1a3
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-class-pwm
> > @@ -0,0 +1,37 @@
> > +What:		/sys/class/pwm/
> > +Date:		March 2013
> > +KernelVersion:	3.11
> > +Contact:	Lars Poeschel <poeschel@lemonage.de>
> > +Description:
> > +
> > +  The sysfs interface for PWM is selectable as a Kconfig option.
> > +  If a driver successfully probed a pwm chip, it appears at
> 
> "PWM chip" please.
> 
> > +  /sys/class/pwm/pwmchipN/ where N is the number of it's first PWM
> > channel. A
> 
> "it's" -> "its"
> 
> Also this highlights a fundamental problem with this patch. I know
> people like to handle PWMs the same as GPIOs, but the problem here is
> that the PWM subsystem was designed to do per-chip indexing. The global
> namespace was introduced only for backwards compatibility. An explicit
> goal was to get rid of the global namespace once all uses of the legacy
> API have been removed.
> 
> This whole sysfs interface relies on the fact that there is some global
> namespace, so if we expose the global namespace to userspace via sysfs
> we make it much harder to get rid of it. So instead of using pwmchipN as
> the name I think it'd be better to use the device name for the directory
> entry in sysfs (much like the backlight, power or other classes).

As mentioned in the commit message I did very much modeled this sysfs 
interface after the gpio sysfs because I thought it would be good to be 
consistent and have the interfaces very similar. I am also no fan of the 
global namespace. I like the idea having the pwm_device exported under its 
pwm_chip with per chip indexing.

> On a side-note, there's really no need to encode the base in the name,
> since you can much more easily obtain it from the base attribute.

This is a carry-over from gpio sysfs and I think this is simply to 
distinguish different chips, even if the driver does not set the name 
attribute.

> > +  After a PWM channel is exported, it is available under
> > +  /sys/class/pwm/pwmN/. Under this directory you can set the 
parameters
> > for +  this PWM channel and at least let it start running.
> 
> I don't understand the last part of this sentence. "at least let it
> start running"?

It should mean: set the parameters ... and after that let the pwm toggle.
 
> > +  See below for the parameters.
> > +  It is recommended to set the period_ns at first and the duty_ns 
after
> > that.
> 
> Why is it recommended to set the period_ns first and then duty_ns? Both
> typically need to be set atomically, which is why the in-kernel function
> that configures a PWM channel takes both as parameters. Can we not post-
> pone setting these until we actually enable the PWM?

It is recommended not required. I wanted to recommend it because there is a 
dependency between the two. If you want set duty to a value bigger than the 
currently set period, it will fail. For a fresh pwm_device both values will 
be 0, so setting duty first will fail. This is I why I recommend it. Right, 
this is a problem that could be solved by setting both values at once, but 
I did not want to do that. Point 1 is that sysfs documentation reads 
"Attributes should be ASCII text files, preferably with only one value
per file.", point 2 is that I expect period to be set more rarely than 
duty. In the most cases I set a period at the beginning and then only 
change the duty for to fade a LED or accellerate/decelerate a motor or 
something. Sure it would not hurt to set period explicitly every time, but 
isn't that annoying ? Post-pone the setting can be done if the PWM is not 
actually running, but not if it is running, see below.
 
> I think further the it might be safer to disable the PWM as soon as any
> of the attributes is written and require the user to explicitly enable
> it again when they have finished configuration.

This is the major point I disagree with you, because it would limit the 
use-cases. I expect the PWM to be dynamic. One use case I need it for is to 
drive an analouge voltage. If I want to change the voltage I could only do 
this with voltage drops inbetween.

> > +Directory structure:
> > +
> > +	/sys/class/pwm
> > +		/export ... asks the kernel to export a PWM to userspace
> > +		/unexport ... to return a PWM to the kernel
> > +		/pwmN ... for each exported PWM #N
> > +			/duty_ns ... r/w, length of duty portion
> > +			/period_ns ... r/w, length of the pwm period
> > +			/polarity ... r/w, normal(0) or inverse(1) polarity
> > +					only created if driver supports it
> 
> This is ambiguous. Do you need to write "normal" or "0" to the file to
> set normal polarity?

0, but I got that point.


> Allowing the attributes to change only while a PWM is enabled is a good
> alternative to disabling it automatically when an attribute is changed.
> I rather like it too. You could return -EBUSY in this case to report the
> reason to the user.

You mean change only while a PWM is disabled ?Ok, as said above, I need to 
be able to change at least the duty cycle while the PWM is running without 
having gaps. But prohibiting changes of the period could be done with 
returning -EBUSY.

> > +run - Write a 1 to this file to start the pwm signal generation, write
> > a 0 to +stop it. Set your desired period_ns, duty_ns and polarity
> > before starting the +pwm.
> 
> "run" -> "enabled" as I mentioned before.
> 
> > +It is recommend to set the period_ns at first and duty_ns after that.
> 
> And this can be dropped if we handle things atomically.

I can imagine providing an alternative way to set period and duty cycle at 
once to setting it seperate, but this can also be confusing.

> > +static int pwm_export(struct pwm_device *pwm)
> > +{
> > +	struct device *dev;
> > +	int status;
> > +
> > +	mutex_lock(&sysfs_lock);
> > +
> > +	if (!test_bit(PWMF_REQUESTED, &pwm->flags) ||
> > +		test_bit(PWMF_EXPORT, &pwm->flags)) {
> > +		pr_debug("pwm %d unavailable (requested=%d, exported=%d)\n",
> > +			pwm->pwm,
> > +			test_bit(PWMF_REQUESTED, &pwm->flags),
> > +			test_bit(PWMF_EXPORT, &pwm->flags));
> > +
> > +		status = -EPERM;
> > +		goto fail_unlock;
> > +	}
> 
> I'm not sure I understand what this is supposed to do. Literally this
> means: If the PWM is not requested by an in-kernel user or if it is
> already exported via sysfs, return -EPERM. That doesn't sound right.
> Something like:
> 
> 	if (test_bit(PWMF_REQUESTED, &pwm->flags))
> 		return -EPERM;
> 
> sounds more like what you want. I'm not sure it should be considered an
> error to export an already exported PWM. If so it might be advantageous
> to use a separate error-code for that:
> 
> 	if (test_bit(PWMF_EXPORTED, &pwm->flags))
> 		return -EBUSY;

You did understand it right!
I am also not sure, if multiple exporting should be an error but at the 
moment I am more convinced about prohibiting it. Multiple users of the same 
PWM sound weird and I think then some export / unexport counting has to be 
done.

> 	dev = device_create(...);
> 	if (IS_ERR(dev))
> 		return PTR_ERR(dev);
> 
> 	chip->exported = true;
> 
> Skimming the patch again, I don't think we really need the exported
> field of the pwm_chip, though.

I am not yet shure, if I really can leave this out. I will see...

> > @@ -159,6 +181,9 @@ struct pwm_chip {
> > 
> >  	struct pwm_device *	(*of_xlate)(struct pwm_chip *pc,
> >  	
> >  					    const struct of_phandle_args *args);
> >  	
> >  	unsigned int		of_pwm_n_cells;
> > 
> > +#ifdef CONFIG_PWM_SYSFS
> > +	unsigned		exported:1;
> > +#endif
> 
> I said this already, but I don't see a need for this flag.

As said, not really sure yet.

I agree to all other points you commented and will respect it in v2 of the 
patch.

Thank you again for the very detailed review!

Regards,
Lars
