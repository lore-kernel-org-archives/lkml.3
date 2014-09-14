Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaINR5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:57:50 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:55887 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaINR5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:57:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140909105310.GC27786@leverpostej>
References: <1410256619-3213-1-git-send-email-ankit.jindal@linaro.org>
 <1410256619-3213-5-git-send-email-ankit.jindal@linaro.org> <20140909105310.GC27786@leverpostej>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Sun, 14 Sep 2014 23:27:27 +0530
Message-ID: <CAPTm99XzJe8RWCaMCauGA9fgzRDNzk4bhZoKFtH3jiDHYek2fA@mail.gmail.com>
Subject: Re: [PATCH 4/5] dt-bindings: Add binding info for Xgene QMTM UIO driver
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>, Rob Herring <robh+dt@kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 September 2014 16:23, Mark Rutland <mark.rutland@arm.com> wrote:
> On Tue, Sep 09, 2014 at 10:56:58AM +0100, Ankit Jindal wrote:
>> This patch adds device tree binding documentation for
>> Xgene QMTM UIO driver.
>>
>> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
>> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
>> ---
>>  .../devicetree/bindings/uio/uio_xgene_qmtm.txt     |   45 ++++++++++++++++++++
>>  1 file changed, 45 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
>>
>> diff --git a/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
>> new file mode 100644
>> index 0000000..b71831b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/uio/uio_xgene_qmtm.txt
>> @@ -0,0 +1,45 @@
>> +APM X-Gene QMTM UIO nodes
>> +
>> +QMTM UIO nodes are defined for user space access to on-chip QMTM device
>> +on APM X-Gene SOC using UIO framework.
>> +
>
> Userspace vs kernel space has precisely _nothing_ to do with a HW
> description.
>
> This doesn't describe at all what the device is (e.g. what does QMTM
> stand for, what is it used for?).
>
> NAK.

QMTM stands for queue manager and traffic manager. It is device managing
the hardware queues. It also implements QoS among hardware queues hence
term "traffic" manager is present in its name.

Sure, I will add more info about the device in the next revision.

The primary purpose of QMTM UIO driver is to expose QMTM HW to
user space so that frameworks like ODP (OpenDataPlane) can use
this from user space.

>
> Please ensure you Cc the devicetree list (devicetree@vger.kernel.org) in
> future.

Sure, will do.

>
>> +Required properties:
>> +- compatible: Should be "apm,xgene-qmtm-uio"
>
> This should definitely not have "uio" in the name.

I added "uio" in compatible string because in future APM might
add separate driver for accessing QMTM from kernel space.

Can you suggest better compatible strings for this UIO driver?

>
>> +- reg: Address and length of the register set for the device. It contains the
>> +  information of registers in the same order as described by reg-names.
>> +- reg-names: Should contain the register set names
>> +  - "csr": QMTM control and status register address space.
>> +  - "fabric": QMTM memory mapped access to queue states.
>
> These look ok, I guess.
>
>> +  - "qpool": Memory location for creating QMTM queues. This could be some
>> +    SRAM or reserved portion of RAM. It is expected that size and location
>> +    of qpool memory will be configurable via bootloader.
>
> I don't follow why this should be described in a reg entry. This is not
> a property of the device; this is a separate resource being assigned to
> the device.

Ok, I will remove it from reg and add "qpool-addr" and "qpool-size"
attributes to
point the location of qpool.

>
> Why can the kernel not allocate this dynamically?

For faster access, this can be on-chip memory as well.

>
> If you need a specific fixed pool, use the reserved-memory bindings.

reserved-memory only apply to RAM, it does not apply to on-chip
SRAMs. Right ?

>
>> +- clocks: Reference to the clock entry.
>
> There is only one clock input to the IP block?

Yes.

>
>> +- num_queues: Number of queues under this QMTM device.
>
> s/_/-/, property names should use '-' rather than '_'.

Sure, will rename it in next revision.

>
>> +- devid: QMTM identification number for the system having multiple QMTM devices
>
> What exactly is this used for? Why is the reg entry not sufficient?

When there are multiple QMTM devices, the devid is used to form a
unique id (a tuple of queue number and device id) for the queues
belonging to this device. Unfortunately, we don't have any register
providing the devid of the device.

>
>> +Optional properties:
>> +- status: Should be "ok" or "disabled" for enabled/disabled. Default is "ok".
>
> This is so standard I don't see the point in documenting it.

Ok, I will remove it in next revision.

>
> Mark.

Thanks,
Ankit
