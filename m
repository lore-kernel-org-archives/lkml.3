Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab3JJAzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:55:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63531 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753264Ab3JJAzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:55:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>,
        platform-driver-x86@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH v4 1/4] backlight: introduce backlight_device_registered
Date: Thu, 10 Oct 2013 03:07:15 +0200
Message-ID: <5834530.Of4OZipDEA@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5255FAC5.2090105@intel.com>
References: <1381214401-24672-1-git-send-email-aaron.lu@intel.com> <2202423.8QyNjoNEPr@vostro.rjw.lan> <5255FAC5.2090105@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 10, 2013 08:54:29 AM Aaron Lu wrote:
> On 10/10/2013 08:25 AM, Rafael J. Wysocki wrote:
> > On Tuesday, October 08, 2013 02:39:58 PM Aaron Lu wrote:
> >> Introduce a new API for modules to query if a specific type of backlight
> >> device has been registered. This is useful for some backlight device
> >> provider module(e.g. ACPI video) to know if a native control
> >> interface(e.g. the interface created by i915) is available and then do
> >> things accordingly(e.g. avoid register its own on Win8 systems).
> >>
> >> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> >> Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> >> Tested-by: Yves-Alexis Perez <corsac@debian.org>
> >> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> ---
> >>  drivers/video/backlight/backlight.c | 31 +++++++++++++++++++++++++++++++
> >>  include/linux/backlight.h           |  4 ++++
> >>  2 files changed, 35 insertions(+)
> >>
> >> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> >> index 94a403a..bf2d71d 100644
> >> --- a/drivers/video/backlight/backlight.c
> >> +++ b/drivers/video/backlight/backlight.c
> >> @@ -21,6 +21,9 @@
> >>  #include <asm/backlight.h>
> >>  #endif
> >>  
> >> +static struct list_head bd_list_head;
> >> +static struct mutex bd_list_mutex;
> > 
> > I'd prefer these two things to be called backlight_dev_list and
> > backlight_dev_list_mutex, respectively.
> 
> OK.
> 
> > 
> >> +
> >>  static const char *const backlight_types[] = {
> >>  	[BACKLIGHT_RAW] = "raw",
> >>  	[BACKLIGHT_PLATFORM] = "platform",
> >> @@ -349,10 +352,32 @@ struct backlight_device *backlight_device_register(const char *name,
> >>  	mutex_unlock(&pmac_backlight_mutex);
> >>  #endif
> >>  
> >> +	mutex_lock(&bd_list_mutex);
> >> +	list_add(&new_bd->entry, &bd_list_head);
> >> +	mutex_unlock(&bd_list_mutex);
> >> +
> >>  	return new_bd;
> >>  }
> >>  EXPORT_SYMBOL(backlight_device_register);
> >>  
> >> +bool backlight_device_registered(enum backlight_type type)
> >> +{
> >> +	bool found = false;
> >> +	struct backlight_device *bd;
> >> +
> >> +	mutex_lock(&bd_list_mutex);
> >> +	list_for_each_entry(bd, &bd_list_head, entry) {
> >> +		if (bd->props.type == type) {
> >> +			found = true;
> >> +			break;
> >> +		}
> >> +	}
> > 
> > Isn't it useful to be able to register more than one backlight device of the
> > same type sometimes?
> 
> I think so for some kind of computers. OTOH, the above function should
> be enough for the problem we are solving here, if someday we need to
> differentiate, we can enhance the code then.

OK

