Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaLAOkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:40:55 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60244 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaLAOkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:40:53 -0500
Message-ID: <547C7D9C.7030909@linaro.org>
Date: Mon, 01 Dec 2014 15:39:24 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, agraf@suse.de, linux-kernel@vger.kernel.org,
        patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: Re: [PATCH v3 3/8] VFIO: platform: forwarded state tested when selecting
 IRQ handler
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org> <1416767760-14487-4-git-send-email-eric.auger@linaro.org> <20141130124730.GD82106@macair>
In-Reply-To: <20141130124730.GD82106@macair>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoffer,
On 11/30/2014 01:47 PM, Christoffer Dall wrote:
> The subject reads strangely, perhaps just:
> 
> VFIO: platform: test forward state when selecting IRQ handler
OK
> 
> On Sun, Nov 23, 2014 at 07:35:55PM +0100, Eric Auger wrote:
>> In case the IRQ is forwarded, the VFIO platform IRQ handler does not
>> need to disable the IRQ anymore.
>>
>> When setting the IRQ handler we now also test the forwarded state. In
>> case the IRQ is forwarded we select the edge handler (no automaske).
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> v2 -> v3:
>> - forwarded state was tested in the handler. Now the forwarded state
>>   is tested before setting the handler. This definitively limits
>>   the dynamics of forwarded state changes but I don't think there is
>>   a use case where we need to be able to change the state at any time.
> 
> user space can change this by calling the VFIO_IRQ_SET_ACTION_TRIGGER
> whenever it wants, right?
yes the user can set/unset the VFIO signaling (and request_irq/free_irq)
using VFIO_IRQ_SET_ACTION_TRIGGER. In this new version I do not allow
changing the forwarded state when the handler is attached (request_irq).

Does it answer your interrogation?

Best Regards

Eric

> 
>> ---
>>  drivers/vfio/platform/vfio_platform_irq.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
>> index 08d400e..61a2920 100644
>> --- a/drivers/vfio/platform/vfio_platform_irq.c
>> +++ b/drivers/vfio/platform/vfio_platform_irq.c
>> @@ -230,8 +230,13 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
>>  {
>>  	struct vfio_platform_irq *irq = &vdev->irqs[index];
>>  	irq_handler_t handler;
>> +	struct irq_data *d;
>> +	bool is_forwarded;
>>  
>> -	if (vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE)
>> +	d = irq_get_irq_data(irq->hwirq);
>> +	is_forwarded = irqd_irq_forwarded(d);
>> +
>> +	if ((vdev->irqs[index].flags & VFIO_IRQ_INFO_MASKABLE) && !is_forwarded)
>>  		handler = vfio_maskable_irq_handler;
>>  	else
>>  		handler = vfio_irq_handler;
>> -- 
>> 1.9.1
>>

