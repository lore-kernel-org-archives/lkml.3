Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbbAZVM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:12:28 -0500
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:54474 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754076AbbAZVM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:12:26 -0500
MIME-Version: 1.0
In-Reply-To: <1421967050.3471.14.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1421957007-720-1-git-send-email-isubramanian@apm.com>
	<1421967050.3471.14.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Mon, 26 Jan 2015 13:12:23 -0800
Message-ID: <CAKh23FmxvV82mVrHq5jv-FE+e6u6CkW+xL_a2_ULAQgP_mM2VA@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: xgene: fix: Out of order descriptor bytes read
From: Iyappan Subramanian <isubramanian@apm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        mlangsdo@redhat.com, patches <patches@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 2:50 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2015-01-22 at 12:03 -0800, Iyappan Subramanian wrote:
>> This patch fixes the following kernel crash,
>>
>>       WARNING: CPU: 2 PID: 0 at net/ipv4/tcp_input.c:3079 tcp_clean_rtx_queue+0x658/0x80c()
>>       Call trace:
>
>>
>> Software writes poison data into the descriptor bytes[15:8] and upon
>> receiving the interrupt, if those bytes are overwritten by the hardware with
>> the valid data, software also reads bytes[7:0] and executes receive/tx
>> completion logic.
>>
>> If the CPU executes the above two reads in out of order fashion, then the
>> bytes[7:0] will have older data and causing the kernel panic.  We have to
>> force the order of the reads and thus this patch introduces read memory
>> barrier between these reads.
>>
>> Signed-off-by: Iyappan Subramanian <isubramanian@apm.com>
>> Signed-off-by: Keyur Chudgar <kchudgar@apm.com>
>> Tested-by: Mark Langsdorf <mlangsdo@redhat.com>
>> ---
>>  drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
>> index 83a5028..3622cdb 100644
>> --- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
>> +++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
>> @@ -369,6 +369,8 @@ static int xgene_enet_process_ring(struct xgene_enet_desc_ring *ring,
>>               if (unlikely(xgene_enet_is_desc_slot_empty(raw_desc)))
>>                       break;
>>
>> +             /* read fpqnum field after dataaddr field */
>> +             smp_rmb();
>>               if (is_rx_desc(raw_desc))
>>                       ret = xgene_enet_rx_frame(ring, raw_desc);
>>               else
>
> Reading your changelog, it looks like you need a plain rmb() here.

rmb() translates into dsb, which in arm64 serializes everything
including instructions and thus expensive compared to dmb.

Do you see any issue with smp_rmb() (which translates into dmb) ?

>
>
>
