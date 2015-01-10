Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbbAJWJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:09:06 -0500
Received: from mail-bl2on0128.outbound.protection.outlook.com ([65.55.169.128]:47482
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755307AbbAJWJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:09:03 -0500
X-WSS-ID: 0NHZEUW-08-8EY-02
X-M-MSG: 
Message-ID: <54B1A2F4.3060707@amd.com>
Date: Sun, 11 Jan 2015 00:08:52 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>
Subject: Re: [BUG] 3.19-rc1 net: less interrupt masking in NAPI
References: <54B18DFF.80400@amd.com>
	 <1420923485.5947.85.camel@edumazet-glaptop2.roam.corp.google.com>
	 <54B199EB.1080004@amd.com>
 <1420926614.5947.89.camel@edumazet-glaptop2.roam.corp.google.com>
 <54B1A22C.2020301@amd.com>
In-Reply-To: <54B1A22C.2020301@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.10.145]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(51704005)(199003)(377454003)(479174004)(377424004)(43784003)(24454002)(106466001)(87936001)(64126003)(65816999)(46102003)(19580395003)(101416001)(59896002)(83506001)(50466002)(19580405001)(64706001)(87266999)(54356999)(50986999)(80316001)(93886004)(76176999)(105586002)(23676002)(97736003)(65956001)(65806001)(86362001)(77156002)(575784001)(15975445007)(2950100001)(47776003)(33656002)(77096005)(62966003)(68736005)(36756003)(92566002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0452022BE1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2015 22:09:00.1195
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/11/2015 12:05 AM, Oded Gabbay wrote:
> 
> 
> On 01/10/2015 11:50 PM, Eric Dumazet wrote:
>> On Sat, 2015-01-10 at 23:30 +0200, Oded Gabbay wrote:
>>
>>> Yes, no problem.
>>> I will update on the result.
>>
>> Please try this more complete patch, solving the TX pressure problem as
>> well, and not lying about NAPI budget. thanks !
>>
>>
>> diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
>> index e398eda07298..5f05b387c0a7 100644
>> --- a/drivers/net/ethernet/atheros/alx/main.c
>> +++ b/drivers/net/ethernet/atheros/alx/main.c
>> @@ -184,15 +184,16 @@ static void alx_schedule_reset(struct alx_priv *alx)
>>  	schedule_work(&alx->reset_wk);
>>  }
>>  
>> -static bool alx_clean_rx_irq(struct alx_priv *alx, int budget)
>> +static int alx_clean_rx_irq(struct alx_priv *alx, int budget)
>>  {
>>  	struct alx_rx_queue *rxq = &alx->rxq;
>>  	struct alx_rrd *rrd;
>>  	struct alx_buffer *rxb;
>>  	struct sk_buff *skb;
>>  	u16 length, rfd_cleaned = 0;
>> +	int work = 0;
>>  
>> -	while (budget > 0) {
>> +	while (work < budget) {
>>  		rrd = &rxq->rrd[rxq->rrd_read_idx];
>>  		if (!(rrd->word3 & cpu_to_le32(1 << RRD_UPDATED_SHIFT)))
>>  			break;
>> @@ -243,7 +244,7 @@ static bool alx_clean_rx_irq(struct alx_priv *alx, int budget)
>>  		}
>>  
>>  		napi_gro_receive(&alx->napi, skb);
>> -		budget--;
>> +		work++;
>>  
>>  next_pkt:
>>  		if (++rxq->read_idx == alx->rx_ringsz)
>> @@ -258,21 +259,22 @@ next_pkt:
>>  	if (rfd_cleaned)
>>  		alx_refill_rx_ring(alx, GFP_ATOMIC);
>>  
>> -	return budget > 0;
>> +	return work;
>>  }
>>  
>>  static int alx_poll(struct napi_struct *napi, int budget)
>>  {
>>  	struct alx_priv *alx = container_of(napi, struct alx_priv, napi);
>>  	struct alx_hw *hw = &alx->hw;
>> -	bool complete = true;
>>  	unsigned long flags;
>> +	bool tx_complete;
>> +	int work;
>>  
>> -	complete = alx_clean_tx_irq(alx) &&
>> -		   alx_clean_rx_irq(alx, budget);
>> +	tx_complete = alx_clean_tx_irq(alx);
>> +	work = alx_clean_rx_irq(alx, budget);
>>  
>> -	if (!complete)
>> -		return 1;
>> +	if (!tx_complete || work == budget)
>> +		return budget;
>>  
>>  	napi_complete(&alx->napi);
>>  
>> @@ -284,7 +286,7 @@ static int alx_poll(struct napi_struct *napi, int budget)
>>  
>>  	alx_post_write(hw);
>>  
>> -	return 0;
>> +	return work;
>>  }
>>  
>>  static irqreturn_t alx_intr_handle(struct alx_priv *alx, u32 intr)
>>
>>
> Hi,
> Checked it and its working.
> Thanks again.
> Please note that I only use this Ethernet controller for NFS and SCP, it is
> not used for development of networking software of any kind, so maybe a more
> extensive testing is needed.
> 
> 	Oded
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

But in any case, you can add:
Tested-by: Oded Gabbay <oded.gabbay@amd.com>

	Oded
