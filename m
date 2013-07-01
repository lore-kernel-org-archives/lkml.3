Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3GAPsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:48:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47006 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3GAPsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:48:09 -0400
Message-ID: <51D1A4B4.2040905@wwwdotorg.org>
Date: Mon, 01 Jul 2013 09:48:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC 2/6] x86: provide platform-devices for boot-framebuffers
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com> <1372112849-670-3-git-send-email-dh.herrmann@gmail.com> <51CB53D7.7030602@wwwdotorg.org> <CANq1E4TJjmq2UFfarkdUF7s5KUPuzfUDiDU5BFfF-5QUsjpDwA@mail.gmail.com>
In-Reply-To: <CANq1E4TJjmq2UFfarkdUF7s5KUPuzfUDiDU5BFfF-5QUsjpDwA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 04:11 AM, David Herrmann wrote:
> Hi
> 
> On Wed, Jun 26, 2013 at 10:49 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/24/2013 04:27 PM, David Herrmann wrote:
>>> The current situation regarding boot-framebuffers (VGA, VESA/VBE, EFI) on
>>> x86 causes troubles when loading multiple fbdev drivers. The global
>>> "struct screen_info" does not provide any state-tracking about which
>>> drivers use the FBs. request_mem_region() theoretically works, but
>>> unfortunately vesafb/efifb ignore it due to quirks for broken boards.
>>>
>>> Avoid this by creating a "platform-framebuffer" device with a pointer
>>> to the "struct screen_info" as platform-data. Drivers can now create
>>> platform-drivers and the driver-core will refuse multiple drivers being
>>> active simultaneously.
>>>
>>> We keep the screen_info available for backwards-compatibility. Drivers
>>> can be converted in follow-up patches.
>>>
>>> Apart from "platform-framebuffer" devices, this also introduces a
>>> compatibility option for "simple-framebuffer" drivers which recently got
>>> introduced for OF based systems. If CONFIG_X86_SYSFB is selected, we
>>> try to match the screen_info against a simple-framebuffer supported
>>> format. If we succeed, we create a "simple-framebuffer" device instead
>>> of a platform-framebuffer.
...

>>> diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c
...
>>> +#else /* CONFIG_X86_SYSFB */
>>> +
>>> +static bool parse_mode(const struct screen_info *si,
>>> +                    struct simplefb_platform_data *mode)
>>> +{
>>> +     return false;
>>> +}
>>> +
>>> +static int create_simplefb(const struct screen_info *si,
>>> +                        const struct simplefb_platform_data *mode)
>>> +{
>>> +     return -EINVAL;
>>> +}
>>> +
>>> +#endif /* CONFIG_X86_SYSFB */
>>
>> Following on from my ifdef comment above, I believe those versions of
>> those functions will always cause add_sysfb() to return -ENODEV, so you
>> may as well provide a static inline for add_sysfb() instead.
> 
> No. add_sysfb() is supposed to always succeed. However, if
> parse_mode/create_simplefb fail, it creates a "platform-framebuffer"
> as fallback. I don't see any way to avoid these ifdefs. Considering
> the explanation above, could you elaborate how you think this should
> work?

Ah, I wasn't getting the fallback mechanism; that if creating a simplefb
wasn't possible or didn't succeed, a platformfb device would be created
instead.

Perhaps the following might be slightly clearer; there are certainly
fewer nesting levels:

static __init int add_sysfb(void)
{
	const struct screen_info *si = &screen_info;
	struct simplefb_platform_data mode;
	struct platform_device *pd;
	bool compatible = false;
	int ret;

	compatible = parse_mode(si, &mode);
	if (compatible) {
		ret = create_simplefb(si, &mode);
		if (!ret)
			return 0;
	}

	pd = platform_device_register_resndata(NULL,
					"platform-framebuffer", 0,
					NULL, 0, si, sizeof(*si));
	ret = IS_ERR(pd) ? PTR_ERR(pd) : 0;

	return ret;
}

