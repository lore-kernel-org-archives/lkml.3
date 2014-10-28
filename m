Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbaJ1IJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:09:13 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64440 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaJ1IJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:09:05 -0400
MIME-Version: 1.0
In-Reply-To: <20141028053429.GI60814@vmdeb7>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
	<1414005163-3461-9-git-send-email-fransklaver@gmail.com>
	<20141028053429.GI60814@vmdeb7>
Date: Tue, 28 Oct 2014 09:09:03 +0100
Message-ID: <CAH6sp9PUSbSj0jWNNv6q=rwqUnpkCoiUBxCUAHSVjP+qrUEa9g@mail.gmail.com>
Subject: Re: [PATCH 8/8] eeepc-laptop: don't assume get_acpi succeeds
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 6:34 AM, Darren Hart <dvhart@infradead.org> wrote:
> On Wed, Oct 22, 2014 at 09:12:43PM +0200, Frans Klaver wrote:
>> In eeepc_hotk_thaw, we assume that get_acpi() will effectively return a
>> bool. However, it is possible that get_acpi() returns an error instead.
>> We should not be writing error values to the ACPI device, even though
>> it's quite possible that we couldn't contact the ACPI device in the
>> first place.
>>
>> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
>> ---
>>  drivers/platform/x86/eeepc-laptop.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
>> index 275a239..14f79ef 100644
>> --- a/drivers/platform/x86/eeepc-laptop.c
>> +++ b/drivers/platform/x86/eeepc-laptop.c
>> @@ -911,7 +911,7 @@ static int eeepc_hotk_thaw(struct device *device)
>>       struct eeepc_laptop *eeepc = dev_get_drvdata(device);
>>
>>       if (eeepc->wlan_rfkill) {
>> -             bool wlan;
>> +             int wlan;
>>
>>               /*
>>                * Work around bios bug - acpi _PTS turns off the wireless led
>> @@ -919,7 +919,8 @@ static int eeepc_hotk_thaw(struct device *device)
>>                * we should kick it ourselves in case hibernation is aborted.
>>                */
>>               wlan = get_acpi(eeepc, CM_ASL_WLAN);
>> -             set_acpi(eeepc, CM_ASL_WLAN, wlan);
>> +             if (wlan >= 0)
>> +                     set_acpi(eeepc, CM_ASL_WLAN, wlan);
>
> And if not? Seems like we should be passing the error code along.

Wouldn't that mean that you cannot thaw the system if the wlan acpi call fails?

I'd rather have my system up and running without wlan, than I'd have
my system down because we couldn't start wlan. This is of course
assuming that returning an error from eeepc_hotk_thaw means the
thawing stops.

Thanks,
Frans
