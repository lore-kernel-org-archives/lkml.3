Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbbAUJDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:03:09 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:59955 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbbAUJC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:02:59 -0500
MIME-Version: 1.0
In-Reply-To: <20150119145050.GF20386@saruman>
References: <1421654209-6486-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
	<1421654209-6486-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
	<20150119145050.GF20386@saruman>
Date: Wed, 21 Jan 2015 17:02:57 +0800
Message-ID: <CAJ1gpc3QhxkvNeyt68Q72AKnjLMkECriwUUYExVjcmTm6pAJgg@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] usb: dwc3: Add quirk for Synopsis device
 disconnection errata
From: Sneeker Yeh <sneeker.yeh@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>, Huang Rui <ray.huang@amd.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe:

Thanks for reviewing these,

2015-01-19 22:50 GMT+08:00 Felipe Balbi <balbi@ti.com>:
> Hi,
>
> On Mon, Jan 19, 2015 at 03:56:47PM +0800, Sneeker Yeh wrote:
>> Synopsis Designware USB3 IP earlier than v3.00a which is configured in silicon
>> with DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1, would need a specific quirk to prevent
>> xhci host controller from dying when device is disconnected.
>>
>> Since DWC_USB3_SUSPEND_ON_DISCONNECT_EN is an IP configuration whose state
>> cannot be checked from software in runtime, it has to be enabled via platform
>> data or device tree.
>>
>> Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
>> ---
>>  Documentation/devicetree/bindings/usb/dwc3.txt |   17 +++++++++++++++++
>>  drivers/usb/dwc3/core.c                        |    6 ++++++
>>  drivers/usb/dwc3/core.h                        |    1 +
>>  drivers/usb/dwc3/host.c                        |    4 ++++
>>  drivers/usb/dwc3/platform_data.h               |    1 +
>>  5 files changed, 29 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
>> index cd7f045..1b78b29 100644
>> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
>> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
>> @@ -37,6 +37,23 @@ Optional properties:
>>   - snps,is-utmi-l1-suspend: true when DWC3 asserts output signal
>>                       utmi_l1_suspend_n, false when asserts utmi_sleep_n
>>   - snps,hird-threshold: HIRD threshold
>> + - snps,has_suspend_on_disconnect: true when IP is configured in silicon with
>> +                     DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1, it can inject a
>> +                     specific quirk to prevent xhci host controller from
>> +                     dying when usb device is disconnected from root hub.
>> +                     Since DWC_USB3_SUSPEND_ON_DISCONNECT_EN is an IP
>> +                     configuration whose state cannot be checked from
>> +                     software in runtime, it has to be enabled via platform
>> +                     data or device tree.
>> +
>> +                     xhci host dying symptom here is caused by that
>> +                     DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1
>> +                     configuration makes IP auto-suspended after PORTCSC is
>> +                     cleared when usb device detached, then an asynchronous
>> +                     disconnection procedure might fail using endpoint
>> +                     command that suspened IP won't have any response to.
>> +
>> +                     this issue is fixed when IP version >= 3.00a.
>>
>>  This is usually a subnode to DWC3 glue to which it is connected.
>>
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index 25ddc39..fbceab1 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -838,6 +838,9 @@ static int dwc3_probe(struct platform_device *pdev)
>>                               "snps,tx_de_emphasis_quirk");
>>               of_property_read_u8(node, "snps,tx_de_emphasis",
>>                               &tx_de_emphasis);
>> +
>> +             dwc->suspend_on_disconnect_quirk = of_property_read_bool(node,
>> +                             "snps,has_suspend_on_disconnect");
>>       } else if (pdata) {
>>               dwc->maximum_speed = pdata->maximum_speed;
>>               dwc->has_lpm_erratum = pdata->has_lpm_erratum;
>> @@ -864,6 +867,9 @@ static int dwc3_probe(struct platform_device *pdev)
>>               dwc->tx_de_emphasis_quirk = pdata->tx_de_emphasis_quirk;
>>               if (pdata->tx_de_emphasis)
>>                       tx_de_emphasis = pdata->tx_de_emphasis;
>> +
>> +             dwc->suspend_on_disconnect_quirk =
>> +                     pdata->has_suspend_on_disconnect;
>>       }
>>
>>       /* default to superspeed if no maximum_speed passed */
>> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
>> index 8090249..d7458ff 100644
>> --- a/drivers/usb/dwc3/core.h
>> +++ b/drivers/usb/dwc3/core.h
>> @@ -832,6 +832,7 @@ struct dwc3 {
>>
>>       unsigned                tx_de_emphasis_quirk:1;
>>       unsigned                tx_de_emphasis:2;
>> +     unsigned                suspend_on_disconnect_quirk:1;
>
> you're missing the comment on the structure and these should be
> alphabetically sorted.

okay, I see, I'll change it like this:

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -692,6 +692,9 @@ struct dwc3_scratchpad_array {
  * @resize_fifos: tells us it's ok to reconfigure our TxFIFO sizes.
  * @setup_packet_pending: true when there's a Setup Packet in FIFO. Workaround
  * @start_config_issued: true when StartConfig command has been issued
+ * @suspend_on_disconnect_quirk: set if core was configured with
+ *                     DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1. Note that there's
+ *                     now way for software to detect this in runtime.
  * @three_stage_setup: set if we perform a three phase setup
  * @disable_scramble_quirk: set if we enable the disable scramble quirk
  * @u2exit_lfps_quirk: set if we enable u2exit lfps quirk
@@ -818,6 +821,7 @@ struct dwc3 {
        unsigned                resize_fifos:1;
        unsigned                setup_packet_pending:1;
        unsigned                start_config_issued:1;
+       unsigned                suspend_on_disconnect_quirk:1;
        unsigned                three_stage_setup:1;

        unsigned                disable_scramble_quirk:1;


>
>> diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
>> index 12bfd3c..9c42074 100644
>> --- a/drivers/usb/dwc3/host.c
>> +++ b/drivers/usb/dwc3/host.c
>> @@ -53,6 +53,10 @@ int dwc3_host_init(struct dwc3 *dwc)
>>       pdata.usb3_lpm_capable = 1;
>>  #endif
>>
>> +     if ((dwc->revision < DWC3_REVISION_300A) &&
>> +         dwc->suspend_on_disconnect_quirk)
>> +             pdata.delay_portcsc_clear = 1;
>> +
>>       ret = platform_device_add_data(xhci, &pdata, sizeof(pdata));
>>       if (ret) {
>>               dev_err(dwc->dev, "couldn't add platform data to xHCI device\n");
>> diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
>> index a3a3b6d..69562f1 100644
>> --- a/drivers/usb/dwc3/platform_data.h
>> +++ b/drivers/usb/dwc3/platform_data.h
>> @@ -44,4 +44,5 @@ struct dwc3_platform_data {
>>
>>       unsigned tx_de_emphasis_quirk:1;
>>       unsigned tx_de_emphasis:2;
>> +     unsigned has_suspend_on_disconnect:1;
>
> needs a comment at the top of this structure and should sorted.

okay, I'll do it like this:

--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -20,6 +20,13 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/otg.h>

+/**
+ * struct dwc3_platform_data - platform data of dwc3 controller
+ * @has_suspend_on_disconnect: true if core was configured with
+ *                     DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1. Note that there's
+ *                     now way for software to detect this in runtime.
+ */
+
 struct dwc3_platform_data {
        enum usb_device_speed maximum_speed;
        enum usb_dr_mode dr_mode;
@@ -32,6 +39,7 @@ struct dwc3_platform_data {

        unsigned disable_scramble_quirk:1;
        unsigned has_lpm_erratum:1;
+       unsigned has_suspend_on_disconnect:1;
        unsigned u2exit_lfps_quirk:1;
        unsigned u2ss_inp3_quirk:1;
        unsigned req_p1p2p3_quirk:1;


Much appreciate,
Sneeker

>
> --
> balbi
