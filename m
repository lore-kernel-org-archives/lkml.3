Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064AbaKUSAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:00:09 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:52276 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750807AbaKUSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:00:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAEP_g=-VEWi2Qo6gcJGr2+NXWEhkuMyu7BiAke6H=x+PTLcNcg@mail.gmail.com>
References: <1416525081-27779-1-git-send-email-joestringer@nicira.com> <CAEP_g=-VEWi2Qo6gcJGr2+NXWEhkuMyu7BiAke6H=x+PTLcNcg@mail.gmail.com>
From: Joe Stringer <joestringer@nicira.com>
Date: Fri, 21 Nov 2014 09:59:41 -0800
Message-ID: <CANr6G5zrA6NUtcyhX1cwEO1Hiq9jnarB36P6m5eoHUFqWWc26Q@mail.gmail.com>
Subject: Re: [PATCHv2 net] i40e: Implement ndo_gso_check()
To: Jesse Gross <jesse@nicira.com>
Cc: netdev <netdev@vger.kernel.org>, Shannon Nelson <shannon.nelson@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tom Herbert <therbert@google.com>, "linux.nics" <linux.nics@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2014 16:19, Jesse Gross <jesse@nicira.com> wrote:
> On Thu, Nov 20, 2014 at 3:11 PM, Joe Stringer <joestringer@nicira.com> wrote:
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> index c3a7f4a..2b01c8d 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> @@ -7447,6 +7447,36 @@ static int i40e_ndo_fdb_dump(struct sk_buff *skb,
>>
>>  #endif /* USE_DEFAULT_FDB_DEL_DUMP */
>>  #endif /* HAVE_FDB_OPS */
>> +static bool i40e_gso_check(struct sk_buff *skb, struct net_device *dev)
>> +{
>> +       if ((skb_shinfo(skb)->gso_type & SKB_GSO_IPIP) &&
>> +           (skb->inner_protocol_type != ENCAP_TYPE_IPPROTO ||
>> +            skb->inner_protocol != htons(IPPROTO_IPIP))) {
>
> I think this check on inner_protocol isn't really semantically correct
> - that field is a union with inner_ipproto, so it would be more
> correct to check against that and then you wouldn't need to use htons
> either.

Yes, translation error on my part, but if IPIP isn't exposed I'll just
drop this section.

> I don't know if we need to have the check at all for IPIP though -
> after all the driver doesn't expose support for it all (actually it
> doesn't expose GRE either). This raises kind of an interesting
> question about the checks though - it's pretty easy to add support to
> the driver for a new GSO type (and I imagine that people will be
> adding GRE soon) and forget to update the check.

If the check is more conservative, then testing would show that it's
not working and lead people to figure out why (and update the check).

>> +       if (skb_shinfo(skb)->gso_type & (SKB_GSO_GRE | SKB_GSO_UDP_TUNNEL)) {
>> +               unsigned char *ihdr;
>> +
>> +               if (skb->inner_protocol_type != ENCAP_TYPE_ETHER)
>> +                       return false;
>
> I guess if you want to be nice, it might be good to check the
> equivalent IP protocol types as well.

Can do (just UDP as I'll drop GRE as per the above).
