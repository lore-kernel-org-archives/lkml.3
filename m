Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaFPPpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:45:05 -0400
Received: from mail-ve0-f196.google.com ([209.85.128.196]:37189 "EHLO
	mail-ve0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaFPPpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:45:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVjd9J=Kz4d88==UsbfjH13mhGzzmbc2NnxSOfqJs_aGpQ@mail.gmail.com>
References: <1402932328-3732-1-git-send-email-xerofoify@gmail.com>
	<539F0DAF.1020802@opengridcomputing.com>
	<CAPDOMVjd9J=Kz4d88==UsbfjH13mhGzzmbc2NnxSOfqJs_aGpQ@mail.gmail.com>
Date: Mon, 16 Jun 2014 11:45:01 -0400
Message-ID: <CAPDOMVh4iBhWe50LZtiotpgWBn3fhX1jofyeAeYW4kHxx+Q4FQ@mail.gmail.com>
Subject: Re: [PATCHv4]Checks for Null value in function *get_skub
From: Nick Krause <xerofoify@gmail.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: swise@chelsio.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we close this bug or is it still a issue as we can'
return NULL from kfree or kfree_skb. Here is the bug
ID 44631 I would close it if we are done with the bug
otherwise I think there are no other issues with
allocating a skb,
Cheers Nick

On Mon, Jun 16, 2014 at 11:37 AM, Nick Krause <xerofoify@gmail.com> wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/
> cm.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index f9477e2..2d56983 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -340,15 +340,13 @@ static int status2errno(int status)
>   */
>  static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>  {
>  if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>                 skb_trim(skb, 0);
>                 skb_get(skb);
>                 skb_reset_transport_header(skb);
>         } else {
> +               if (skb)
> /* NULL is ignored */.
> +                       kfree_skb (skb);
>                 skb = alloc_skb(len, gfp);
>         }
>         t4_set_arp_err_handler(skb, NULL, NULL);
>
> On Mon, Jun 16, 2014 at 11:30 AM, Steve Wise
> <swise@opengridcomputing.com> wrote:
>> On 6/16/2014 10:25 AM, Nicholas Krause wrote:
>>>
>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>> ---
>>>   drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
>>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/infiniband/hw/cxgb4/cm.c
>>> b/drivers/infiniband/hw/cxgb4/cm.c
>>> index f9477e2..2d56983 100644
>>> --- a/drivers/infiniband/hw/cxgb4/cm.c
>>> +++ b/drivers/infiniband/hw/cxgb4/cm.c
>>> @@ -340,15 +340,13 @@ static int status2errno(int status)
>>>    */
>>>   static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>>>   {
>>>   if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>>>                  skb_trim(skb, 0);
>>>                  skb_get(skb);
>>>                  skb_reset_transport_header(skb);
>>>         } else {
>>> +               if (skb)
>>> +                       kfree_skb (skb);
>>>                 skb = alloc_skb(len, gfp);
>>>         }
>>>         t4_set_arp_err_handler(skb, NULL, NULL);
>>
>>
>> Can you change the comment?  This patch is now fixing a potential skb leak.
>> Also, kfree_sb() will ignore NULL ptrs, so we could just always call it.
>> But I'd add a comment like /* NULL is ignored */.
>>
>> Thanks,
>>
>> Steve.
