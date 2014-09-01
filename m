Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaIAOMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:12:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:15472 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbaIAOMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:12:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,442,1406617200"; 
   d="scan'208";a="566627609"
From: Jani Nikula <jani.nikula@intel.com>
To: imre.deak@intel.com, Dave Airlie <airlied@gmail.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@redhat.com>
Subject: Re: [Intel-gfx] [drm/i915/3.17] panic in i915_digport_work_func
In-Reply-To: <1409578107.12004.20.camel@intelbox>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1409382202.5141.36.camel@marge.simpson.net> <1409486735.4991.19.camel@marge.simpson.net> <CAPM=9txZ5mS3u-7FrjCMF6T3sATfAU2Y+fpyXi-REPWXExBajA@mail.gmail.com> <1409578107.12004.20.camel@intelbox>
User-Agent: Notmuch/0.18.1+84~g658a00e (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 01 Sep 2014 17:11:55 +0300
Message-ID: <87fvgbfn10.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Imre Deak <imre.deak@intel.com> wrote:
> On Mon, 2014-09-01 at 17:02 +1000, Dave Airlie wrote:
>> From: Dave Airlie <airlied@redhat.com>
>> Date: Mon, 1 Sep 2014 16:58:12 +1000
>> Subject: [PATCH] drm/i915: handle G45/GM45 pulse detection connected
>> state.
>> 
>> In the HPD pulse handler we check for long pulses if the port is
>> actually
>> connected, however we do that for IBX, but we use the pulse handling
>> code on
>> GM45 systems as well, so we need to use a diffent check.
>> 
>> This patch refactors the digital port connected check out of the g4x
>> detection
>> path and reuses it in the hpd pulse path.
>> 
>> Should fix:
>> Message-ID: <1409382202.5141.36.camel@marge.simpson.net>
>> 
>> Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
>> Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> Daniel reviewed this already, but Jani asked me to take a look, so:
> Acked-by: Imre Deak <imre.deak@intel.com>

Pushed to drm-intel-fixes, thanks for the patch, review, and testing.

BR,
Jani.

>
> One thing for the future is to move ibx_digital_port_connected() to
> intel_dp.c too and make its return value match that of
> g4x_digital_port_connected().
>
> --Imre
>
>> ---
>>  drivers/gpu/drm/i915/intel_dp.c | 55
>> +++++++++++++++++++++++++++--------------
>>  1 file changed, 37 insertions(+), 18 deletions(-)
>> 
>> diff --git a/drivers/gpu/drm/i915/intel_dp.c
>> b/drivers/gpu/drm/i915/intel_dp.c
>> index 67cfed6..81d7681 100644
>> --- a/drivers/gpu/drm/i915/intel_dp.c
>> +++ b/drivers/gpu/drm/i915/intel_dp.c
>> @@ -3661,24 +3661,12 @@ ironlake_dp_detect(struct intel_dp *intel_dp)
>>         return intel_dp_detect_dpcd(intel_dp);
>>  }
>>  
>> -static enum drm_connector_status
>> -g4x_dp_detect(struct intel_dp *intel_dp)
>> +static int g4x_digital_port_connected(struct drm_device *dev,
>> +                                      struct intel_digital_port
>> *intel_dig_port)
>>  {
>> -       struct drm_device *dev = intel_dp_to_dev(intel_dp);
>>         struct drm_i915_private *dev_priv = dev->dev_private;
>> -       struct intel_digital_port *intel_dig_port =
>> dp_to_dig_port(intel_dp);
>>         uint32_t bit;
>>  
>> -       /* Can't disconnect eDP, but you can close the lid... */
>> -       if (is_edp(intel_dp)) {
>> -               enum drm_connector_status status;
>> -
>> -               status = intel_panel_detect(dev);
>> -               if (status == connector_status_unknown)
>> -                       status = connector_status_connected;
>> -               return status;
>> -       }
>> -
>>         if (IS_VALLEYVIEW(dev)) {
>>                 switch (intel_dig_port->port) {
>>                 case PORT_B:
>> @@ -3691,7 +3679,7 @@ g4x_dp_detect(struct intel_dp *intel_dp)
>>                         bit = PORTD_HOTPLUG_LIVE_STATUS_VLV;
>>                         break;
>>                 default:
>> -                       return connector_status_unknown;
>> +                       return -EINVAL;
>>                 }
>>         } else {
>>                 switch (intel_dig_port->port) {
>> @@ -3705,11 +3693,36 @@ g4x_dp_detect(struct intel_dp *intel_dp)
>>                         bit = PORTD_HOTPLUG_LIVE_STATUS_G4X;
>>                         break;
>>                 default:
>> -                       return connector_status_unknown;
>> +                       return -EINVAL;
>>                 }
>>         }
>>  
>>         if ((I915_READ(PORT_HOTPLUG_STAT) & bit) == 0)
>> +               return 0;
>> +       return 1;
>> +}
>> +
>> +static enum drm_connector_status
>> +g4x_dp_detect(struct intel_dp *intel_dp)
>> +{
>> +       struct drm_device *dev = intel_dp_to_dev(intel_dp);
>> +       struct intel_digital_port *intel_dig_port =
>> dp_to_dig_port(intel_dp);
>> +       int ret;
>> +
>> +       /* Can't disconnect eDP, but you can close the lid... */
>> +       if (is_edp(intel_dp)) {
>> +               enum drm_connector_status status;
>> +
>> +               status = intel_panel_detect(dev);
>> +               if (status == connector_status_unknown)
>> +                       status = connector_status_connected;
>> +               return status;
>> +       }
>> +
>> +       ret = g4x_digital_port_connected(dev, intel_dig_port);
>> +       if (ret == -EINVAL)
>> +               return connector_status_unknown;
>> +       else if (ret == 0)
>>                 return connector_status_disconnected;
>>  
>>         return intel_dp_detect_dpcd(intel_dp);
>> @@ -4066,8 +4079,14 @@ intel_dp_hpd_pulse(struct intel_digital_port
>> *intel_dig_port, bool long_hpd)
>>         intel_display_power_get(dev_priv, power_domain);
>>  
>>         if (long_hpd) {
>> -               if (!ibx_digital_port_connected(dev_priv,
>> intel_dig_port))
>> -                       goto mst_fail;
>> +
>> +               if (HAS_PCH_SPLIT(dev)) {
>> +                       if (!ibx_digital_port_connected(dev_priv,
>> intel_dig_port))
>> +                               goto mst_fail;
>> +               } else {
>> +                       if (g4x_digital_port_connected(dev,
>> intel_dig_port) != 1)
>> +                               goto mst_fail;
>> +               }
>>  
>>                 if (!intel_dp_get_dpcd(intel_dp)) {
>>                         goto mst_fail;
>

-- 
Jani Nikula, Intel Open Source Technology Center
