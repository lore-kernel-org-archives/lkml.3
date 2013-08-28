Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3H1Me5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:34:57 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13097 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3H1Me4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:34:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Aug 2013 05:32:23 -0700
Message-ID: <521DEE6D.4050503@nvidia.com>
Date: Wed, 28 Aug 2013 15:34:53 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] host1x: hdmi: Detect whether display is connected
 with HDMI or DVI
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com> <1377686459-16634-3-git-send-email-mperttunen@nvidia.com> <20130828120727.GA32254@ulmo>
In-Reply-To: <20130828120727.GA32254@ulmo>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 03:07 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Wed, Aug 28, 2013 at 01:40:56PM +0300, Mikko Perttunen wrote:
>> Use EDID data to determine whether the display supports HDMI or just DVI.
>> This used to be hardcoded to be HDMI, which broke support for DVI displays
>> that couldn't understand the interspersed audio/other data.
>>
>> If the EDID data isn't available, default to DVI, which should be a safer
>> choice.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>>   drivers/gpu/host1x/drm/hdmi.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
>> index d81fac8..140339b 100644
>> --- a/drivers/gpu/host1x/drm/hdmi.c
>> +++ b/drivers/gpu/host1x/drm/hdmi.c
>> @@ -702,6 +702,14 @@ static int tegra_output_hdmi_enable(struct tegra_output *output)
>>   	unsigned long value;
>>   	int retries = 1000;
>>   	int err;
>> +	struct drm_property_blob *edid_blob = output->connector.edid_blob_ptr;
>> +
>> +	if (edid_blob && edid_blob->data &&
>> +		drm_detect_hdmi_monitor((struct edid *)edid_blob->data)) {
>> +		hdmi->dvi = false;
>> +	} else {
>> +		hdmi->dvi = true;
>> +	}
>>
>>   	pclk = mode->clock * 1000;
>>   	h_sync_width = mode->hsync_end - mode->hsync_start;
>
> Odd, now that I see that code I remember that there was a similar patch
> a few months back, but it was never applied for some reason:
>
> 	http://lists.freedesktop.org/archives/dri-devel/2013-January/033509.html
>
> That was already reviewed by me and Jon Mayo, so I'll go ahead and apply
> that one instead.
>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>

That patch seems to cause a warning for me:
drivers/gpu/host1x/drm/hdmi.c: In function ‘tegra_output_hdmi_enable’:
drivers/gpu/host1x/drm/hdmi.c:706:2: warning: passing argument 1 of 
‘drm_detect_hdmi_monitor’ discards ‘const’ qualifier from pointer target 
type [enabled by default]
include/drm/drm_crtc.h:1037:13: note: expected ‘struct edid *’ but 
argument is of type ‘const struct edid *’

Looks much nicer though.
