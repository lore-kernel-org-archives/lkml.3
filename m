Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaLXQlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:41:51 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:35839 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaLXQlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:41:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Dec 2014 17:41:29 +0100
From: Stefan Agner <stefan@agner.ch>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: Peter.Chen@freescale.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: chipidea: Add identification registers access
 APIs
In-Reply-To: <549AE6A3.3060009@gmail.com>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
 <72124df17c0f40f8a7ae02faa9664b9d51743584.1418981438.git.maitysanchayan@gmail.com>
 <4f5efe169ed3ab16ffcbee52dd6b7661@agner.ch> <549AE6A3.3060009@gmail.com>
Message-ID: <c38f5f71f018cbbb71f8e544735c59a3@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Dec 24 17:40:39 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 549aec8712814706726210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-24 17:15, Sanchayan Maity wrote:
> On 12/24/2014 09:30 PM, Stefan Agner wrote:
>> On 2014-12-19 10:55, Sanchayan Maity wrote:
>>> Using hw_write_id_reg and hw_read_id_reg to write and read
>>> identification registers contents. This can be used to get
>>> controller information, change some system configurations
>>> and so on.
>>
>> Checkpatch is complaining about DOS line endings and some trailing
>> whitespace. This applies to all three patches.
> 
> Hmm... that's surprising. I did run checkpatch at my end before sending.
> I do not have the original patchset on my laptop which I have right now
> but downloading diffs back from lkml and running checkpatch on them back,
> only gives me signed off errors as it should. 
> 

You are right, it's on my side. My webmailer (Roundcube) seem to
introduce those line endings when using "Download (.eml)". Using "Show
Source", and then save the e-mail makes checkpatch happy... Sorry about
that.

--
Stefan

> I will resend if somehow errors crept in with my earlier patches.
> 
> -Sanchayan
> 
>>
>>>
>>> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
>>> ---
>>>  drivers/usb/chipidea/ci.h |   53 +++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 53 insertions(+)
>>>
>>> diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
>>> index ea40626..94db636 100644
>>> --- a/drivers/usb/chipidea/ci.h
>>> +++ b/drivers/usb/chipidea/ci.h
>>> @@ -29,6 +29,15 @@
>>>  /******************************************************************************
>>>   * REGISTERS
>>>   *****************************************************************************/
>>> +/* Identification Registers */
>>> +#define ID_ID				0x0
>>> +#define ID_HWGENERAL			0x4
>>> +#define ID_HWHOST			0x8
>>> +#define ID_HWDEVICE			0xc
>>> +#define ID_HWTXBUF			0x10
>>> +#define ID_HWRXBUF			0x14
>>> +#define ID_SBUSCFG			0x90
>>> +
>>>  /* register indices */
>>>  enum ci_hw_regs {
>>>  	CAP_CAPLENGTH,
>>> @@ -97,6 +106,18 @@ enum ci_role {
>>>  	CI_ROLE_END,
>>>  };
>>>
>>> +enum CI_REVISION {
>>
>> Usually the enum names are small caps, only the labels are capitalized.
>> I would suggest use ci_revision here (similar to the enum above).
>>
>>> +	CI_REVISION_1X = 10,	/* Revision 1.x */
>>> +	CI_REVISION_20 = 20, /* Revision 2.0 */
>>> +	CI_REVISION_21, /* Revision 2.1 */
>>> +	CI_REVISION_22, /* Revision 2.2 */
>>> +	CI_REVISION_23, /* Revision 2.3 */
>>> +	CI_REVISION_24, /* Revision 2.4 */
>>> +	CI_REVISION_25, /* Revision 2.5 */
>>> +	CI_REVISION_25_PLUS, /* Revision above than 2.5 */
>>> +	CI_REVISION_UNKNOWN = 99, /* Unknown Revision */
>>> +};
>>> +
>>>  /**
>>>   * struct ci_role_driver - host/gadget role driver
>>>   * @start: start this role
>>> @@ -168,6 +189,7 @@ struct hw_bank {
>>>   * @b_sess_valid_event: indicates there is a vbus event, and handled
>>>   * at ci_otg_work
>>>   * @imx28_write_fix: Freescale imx28 needs swp instruction for writing
>>> + * @rev: The revision number for controller
>>>   */
>>>  struct ci_hdrc {
>>>  	struct device			*dev;
>>> @@ -207,6 +229,7 @@ struct ci_hdrc {
>>>  	bool				id_event;
>>>  	bool				b_sess_valid_event;
>>>  	bool				imx28_write_fix;
>>> +	enum CI_REVISION		rev;
>>>  };
>>>
>>>  static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
>>> @@ -244,6 +267,36 @@ static inline void ci_role_stop(struct ci_hdrc *ci)
>>>  }
>>>
>>>  /**
>>> + * hw_read_id_reg: reads from a identification register
>>> + * @ci: the controller
>>> + * @offset: offset from the beginning of identification registers region
>>> + * @mask: bitfield mask
>>> + *
>>> + * This function returns register contents
>>> + */
>>> +static inline u32 hw_read_id_reg(struct ci_hdrc *ci, u32 offset, u32 mask)
>>> +{
>>> +	return ioread32(ci->hw_bank.abs + offset) & mask;
>>> +}
>>> +
>>> +/**
>>> + * hw_write_id_reg: writes to a identification register
>>> + * @ci: the controller
>>> + * @offset: offset from the beginning of identification registers region
>>> + * @mask: bitfield mask
>>> + * @data: new value
>>> + */
>>> +static inline void hw_write_id_reg(struct ci_hdrc *ci, u32 offset,
>>> +			    u32 mask, u32 data)
>>> +{
>>> +	if (~mask)
>>> +		data = (ioread32(ci->hw_bank.abs + offset) & ~mask)
>>> +			| (data & mask);
>>> +
>>> +	iowrite32(data, ci->hw_bank.abs + offset);
>>> +}
>>
>> This function isn't used anywhere, does it make sense to write an ID
>> register? The ones I see in Vybrid's RM are read-only anyway..
>>
>> --
>> Stefan
>>
>>> +
>>> +/**
>>>   * hw_read: reads from a hw register
>>>   * @ci: the controller
>>>   * @reg:  register index
>>

