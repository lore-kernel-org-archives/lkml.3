Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbaLAWQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:16:46 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:59358 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbaLAWQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:16:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Dec 2014 23:18:47 +0100
From: Stefan Agner <stefan@agner.ch>
To: Guenter Roeck <linux@roeck-us.net>, Feng Kan <fkan@apm.com>,
        mark.rutland@arm.com
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, Arnd Bergmann <arnd@arndb.de>,
        sre@kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] power: reset: read priority from device tree
In-Reply-To: <20141201174215.GB24692@roeck-us.net>
References: <1417453389-1588-1-git-send-email-stefan@agner.ch>
 <1417453389-1588-2-git-send-email-stefan@agner.ch>
 <CAL85gmBq30pWxP0buKbM8so6QqsJq2YojiSK1EWtMPsH_7foeg@mail.gmail.com>
 <ea4f7a2bfdb9bea45cab9418c211083b@agner.ch>
 <CAL85gmBNE7oDbE+LX+V=AFJO61Ta0Gekoq6sDb8TkEnoPsNFVA@mail.gmail.com>
 <20141201174215.GB24692@roeck-us.net>
Message-ID: <3916ca2867ced70e16903d6d44aaae8f@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Dec  1 23:16:09 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 547ce8a912813582220642
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-01 18:42, Guenter Roeck wrote:
> On Mon, Dec 01, 2014 at 09:38:09AM -0800, Feng Kan wrote:
>> On Mon, Dec 1, 2014 at 9:29 AM, Stefan Agner <stefan@agner.ch> wrote:
>> > On 2014-12-01 18:15, Feng Kan wrote:
>> >> On Mon, Dec 1, 2014 at 9:03 AM, Stefan Agner <stefan@agner.ch> wrote:
>> >>> This patch adds an optional property which allows to specify the
>> >>> reset source priority. This priority is used by the kernel restart
>> >>> handler call chain to sort out the proper reset/restart method.
>> >>> Depending on the power design of a board or other machine/board
>> >>> specific peculiarity, it is not possible to pick a generic priority.
>> >>>
>> >>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> >>> ---
>> >>>  Documentation/devicetree/bindings/power/reset/syscon-reboot.txt | 3 +++
>> >>>  drivers/power/reset/syscon-reboot.c                             | 5 ++++-
>> >>>  2 files changed, 7 insertions(+), 1 deletion(-)
>> >>>
>> >>> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> >>> index 1190631..ee41d9c 100644
>> >>> --- a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> >>> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
>> >>> @@ -11,6 +11,9 @@ Required properties:
>> >>>  - offset: offset in the register map for the reboot register (in bytes)
>> >>>  - mask: the reset value written to the reboot register (32 bit access)
>> >>>
>> >>> +Optional properties:
>> >>> +- priority: define the priority of the reset (0-255, defaults to 128)
>> >>> +
>> >>>  Default will be little endian mode, 32 bit access only.
>> >>>
>> >>>  Examples:
>> >>> diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
>> >>> index 815b901..3060d6b 100644
>> >>> --- a/drivers/power/reset/syscon-reboot.c
>> >>> +++ b/drivers/power/reset/syscon-reboot.c
>> >>> @@ -67,8 +67,11 @@ static int syscon_reboot_probe(struct platform_device *pdev)
>> >>>         if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
>> >>>                 return -EINVAL;
>> >>>
>> >>> -       ctx->restart_handler.notifier_call = syscon_restart_handle;
>> >>>         ctx->restart_handler.priority = 128;
>> >>> +       of_property_read_u32(pdev->dev.of_node, "priority",
>> >>> +                            &ctx->restart_handler.priority);
>> >>
>> >> What is this for?
>> >
>> > What do you mean? The moved line "ctx->restart_handler.notifier_call =
>> > syscon_restart_handle;"? When one reads the diff, it looks like that
>> > line was moved, in fact I tried to keep the of_property_read function
>> > calls together. But I had to move the assignation of the default
>> > priority in front of restart_handler.priority. That's what is the
>> > outcome...
>>
>> I believe Guenter explained above already. Actually this help to solve one of
>> my problem. Thanks.
> 
> Since Mark doesn't seem to be happy with the idea of making the priority
> dt-configurable, the alternative might be to just set a higher priority for
> syscon triggered resets, as suggested by Stefan. Not as flexible, but it
> should be ok for most use cases.
> 

I read the other branch of this thread too, but IMHO, this would be the
best solution for now. It's a one line change and does the job. After
all, we have that priority for a reason, it doesn't makes sense having
all of them at a common default. As mentioned in an other reply, I think
it is especially reasonable to configure the syscon-reboot driver a bit
higher, since this driver is more likely to be used for a dedicated
reboot feature provided by the SoC, which usually is the preferred one.
If it happens one day that a SoC ends up with conflicting priorities or
other priority odds, we can add the DT support then...

What do you think, can I go with that for now? (Guenter, Feng, Mark...?)

--
Stefan

