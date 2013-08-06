Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3HFVNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:13:51 -0400
Received: from mail1-ar.fullrate.dk ([90.185.0.67]:36561 "EHLO
	mail1-ar.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3HFVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:13:49 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2013 17:13:48 EDT
Message-ID: <520164A5.2020008@molgaard.org>
Date: Tue, 06 Aug 2013 23:03:33 +0200
From: =?UTF-8?B?U3VuZSBNw7hsZ2FhcmQ=?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:25.0) Gecko/20100101 Firefox/25.0 SeaMonkey/2.22a1
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
CC: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        joseph.salisbury@canonical.com,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] HID: hid-logitech-dj, querying_devices was never
 set
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>	<1374153691-25100-2-git-send-email-nlopezcasad@logitech.com>	<CAN+gG=GcS7pfK9K5FuW9TyX+PJWNkXZWLk8UX9PzLXom2PSpgQ@mail.gmail.com>	<alpine.LNX.2.00.1308020309340.24017@pobox.suse.cz>	<CAN+gG=FV=OjnktkET-_KM_iTPStsWCKdj8fpyktnJczusFz0=w@mail.gmail.com>	<alpine.LNX.2.00.1308051516181.17512@pobox.suse.cz> <CAN+gG=Hjd1Ay0=HrJdV9797DxTMf97_13kdkuHNWi24EfPL-ig@mail.gmail.com>
In-Reply-To: <CAN+gG=Hjd1Ay0=HrJdV9797DxTMf97_13kdkuHNWi24EfPL-ig@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being affected by this bug, I can confirm that Linux 3.11-rc4 still
exhibits the unwanted behaviour for me, but that commenting out the
single line from the second patch makes it work.

Thus, for requesting a revert on that line, you are most welcome to put
me down as a "Tested-By".

Best regards,

Sune Mølgaard

Benjamin Tissoires wrote:
> On Mon, Aug 5, 2013 at 3:22 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>> On Fri, 2 Aug 2013, Benjamin Tissoires wrote:
>>
>>>> Could you please elaborate? (and put an elaborate description to revert
>>>> commit log perhaps?)
>>>
>>> Sure, so here is the revert commit log:
>>>
>>> --
>>>
>>> Commit "HID: hid-logitech-dj, querying_devices was never set" activate
>>> a flag which guarantees that we do not ask the receiver for too many
>>> enumeration. When the flag is set, each following enumeration call is
>>> discarded (the usb request is not forwarded to the receiver). The flag
>>> is then released when the driver receive a pairing information event,
>>> which normally follows the enumeration request.
>>> However, the USB3 bug makes the driver think the enumeration request
>>> has been forwarded to the receiver. However, it is actually not the
>>> case because the USB stack returns -EPIPE. So, when a new unknown
>>> device appears, the workaround consisting in asking for a new
>>> enumeration is not working anymore: this new enumeration is discarded
>>> because of the flag, which is never reset.
>>>
>>> A solution could be to trigger a timeout before releasing it, but for
>>> now, let's just revert the patch.
>>>
>>> --
>>
>> Thanks Benjamin.
>>
>> I'd like to have a bit more clarification about the USB3 bug, as this
>> whole issue is not completely clear to me.
>>
>> To be more specific -- when exactly do we receive -EPIPE, why do we
>> receive it and why do we not handle it properly?
> 
> Sure, I'll try (though the more I think of it, the more it seems
> blurry to me :( ).
> 
> So the initial probe function in hid-logitech-dj was implemented by
> using a direct call to hid_output_raw_report(). This call was
> synchronous, so we did get the -EPIPE return code. Then, the probe()
> function returns the -EPIPE error, cleaning the receiver and
> unregister it from the hid bus.
> 
> However, now, we use hid_hw_request(), which is asynchronous (from
> what I can read). At least, this code returns "void" as the set_report
> command seems to be scheduled for later handling. In usbhid, when the
> queue is flushed, I did not found a way to retrieve the error code...
> 
> So basically, the -EPIPE is received in usbhid_restart_ctrl_queue(),
> but nothing notifies hid-logitech-dj from the error. In the end, the
> probe() function returns without error code, but the receiver never
> received the notification.
> 
> Cheers,
> Benjamin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


-- 
"Testiculos habet et bene pendentes"
See http://www.newint.org/features/1993/06/05/curious/
