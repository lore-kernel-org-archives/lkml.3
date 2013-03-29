Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3C2P3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:29:17 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.14]:61984 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937Ab3C2P3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:29:15 -0400
X-Env-Sender: Max.Nekludov@us.elster.com
X-Msg-Ref: server-15.tower-136.messagelabs.com!1364570954!6789046!1
X-Originating-IP: [129.179.1.27]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
In-Reply-To: <CAOJe8K1LbPgBN5kgXF5W2Fg_JM0BGp69+auSZ6Nk+3appmXZOg@mail.gmail.com>
References: <OF2DFE75BF.1BA5B9C8-ON44257B3D.00492A11-44257B3D.0049472A@gb.elster.com> <CAOJe8K1LbPgBN5kgXF5W2Fg_JM0BGp69+auSZ6Nk+3appmXZOg@mail.gmail.com>
Subject: Re: Fw: Bug in ks8851.c
X-KeepSent: 95B2AB6A:BE754AB4-44257B3D:00544464;
 type=4; name=$KeepSent
To: kda@linux-powerpc.org
Cc: "David S. Miller" <davem@davemloft.net>, Greg Ungerer <gerg@uclinux.org>,
        Jiri Pirko <jiri@resnulli.us>, linus971@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Renzelmann <mjr@cs.wisc.edu>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Lotus Notes Release 8.5.2FP3 July 11, 2011
Message-ID: <OF95B2AB6A.BE754AB4-ON44257B3D.00544464-44257B3D.0054ECCB@gb.elster.com>
From: Max.Nekludov@us.elster.com
Date: Fri, 29 Mar 2013 19:27:36 +0400
X-MIMETrack: Serialize by Router on US-SMTP01.domino.elster-group.com/RIM-TEMP(Release
 8.5.2FP3|July 10, 2011) at 03/29/2013 11:17:25 AM
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis,
here is patch with commit message:

Subject: [PATCH] Fix bug in ks8851 driver

According to the Datasheet (page 52):
15-12 Reserved
11-0 RXBC Receive Byte Count
This field indicates the present received frame byte size.

The code has a bug:
                 rxh = ks8851_rdreg32(ks, KS_RXFHSR);
                 rxstat = rxh & 0xffff;
                 rxlen = rxh >> 16; // BUG!!! 0xFFF mask should be applied

Signed-off-by: Max Nekludov <Max.Nekludov@us.elster.com>
---
drivers/net/ethernet/micrel/ks8851.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c
b/drivers/net/ethernet/micrel/ks8851.c
index 33bcb63d56a2..8fb481252e2c 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -528,7 +528,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 	for (; rxfc != 0; rxfc--) {
 		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
 		rxstat = rxh & 0xffff;
-		rxlen = rxh >> 16;
+		rxlen = (rxh >> 16) & 0xfff;

 		netif_dbg(ks, rx_status, ks->netdev,
 			  "rx: stat 0x%04x, len 0x%04x\n", rxstat, rxlen);


|------------>
| From:      |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Denis Kirjanov <kda@linux-powerpc.org>                                                                                                            |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| To:        |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Max.Nekludov@us.elster.com                                                                                                                        |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Cc:        |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Linus Torvalds <torvalds@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jiri@resnulli.us>, linus971@gmail.com, Linux |
  |Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Renzelmann <mjr@cs.wisc.edu>, Network Development <netdev@vger.kernel.org>, Stephen Boyd |
  |<sboyd@codeaurora.org>, Greg Ungerer <gerg@uclinux.org>, linux-arm-kernel@lists.infradead.org                                                     |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Date:      |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |29.03.2013 18:07                                                                                                                                  |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
|------------>
| Subject:   |
|------------>
  >--------------------------------------------------------------------------------------------------------------------------------------------------|
  |Re: Fw: Bug in ks8851.c                                                                                                                           |
  >--------------------------------------------------------------------------------------------------------------------------------------------------|





please respin this patch with a commit description.

On 3/29/13, Max.Nekludov@us.elster.com <Max.Nekludov@us.elster.com> wrote:
>
> Linus,
>
> I tried to send the mail to 'Ben Dooks <ben@simtec.co.uk>' but the
address
> is dead now.
>> I assume you've tested it in practice?
> Yes, I'm running the modified code both in bootloader and Linux kernel on
> my board.
>
> Thanks,
> Max
>
>  Signed-off-by: Max Nekludov <Max.Nekludov@us.elster.com>
>  ---
>  drivers/net/ethernet/micrel/ks8851.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/micrel/ks8851.c
> b/drivers/net/ethernet/micrel/ks8851.c
> index 33bcb63d56a2..8fb481252e2c 100644
> --- a/drivers/net/ethernet/micrel/ks8851.c
> +++ b/drivers/net/ethernet/micrel/ks8851.c
> @@ -528,7 +528,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>  		 for (; rxfc != 0; rxfc--) {
>  		 		 rxh = ks8851_rdreg32(ks, KS_RXFHSR);
>  		 		 rxstat = rxh & 0xffff;
> -		 		 rxlen = rxh >> 16;
> +		 		 rxlen = (rxh >> 16) & 0xfff;
>
>  		 		 netif_dbg(ks, rx_status, ks->netdev,
>  		 		 		   "rx: stat 0x%04x, len 0x%04x\n",
rxstat, rxlen);
>
>
>
>
> Max,
>  please cc the actual maintainers of the driver. The patch looks sane,
> though. I assume you've tested it in practice?
>
> You also seem to have based this on an ancient version, the code has
> long since moved from drivers/net/ks8851.c to
> drivers/net/ethernet/micrel/ks8851.c (back in June of 2011), and it's
> missing a sign-off from you.
>
> I'm attaching an updated patch for the rename/capitalization issue.
>
>      Linus
>
> On Thu, Mar 28, 2013 at 11:25 AM,  <Max.Nekludov@us.elster.com> wrote:
>>
>> According to the Datasheet (page 52):
>> 15-12 Reserved
>> 11-0 RXBC Receive Byte Count
>> This field indicates the present received frame byte size.
>>
>> I suppose the code has a bug:
>>                 rxh = ks8851_rdreg32(ks, KS_RXFHSR);
>>                 rxstat = rxh & 0xffff;
>>                 rxlen = rxh >> 16; // BUG!!! 0xFFF mask should be
applied
>>
>> P.S.
>> without bit mask applied I saw rxlen equal to 15360 which is bigger then
>> entire RX queue size (12KB).
>>
>> Thanks,
>> Max Nekludov
>>
>> From cb3199cee4490f98d6062e32a75ca377a32b55bc Mon Sep 17 00:00:00 2001
>> From: Max Neklyudov <macscomp@gmail.com>
>> Date: Tue, 26 Mar 2013 11:46:57 +0400
>> Subject: [PATCH] Fix bug in ks8851 driver
>>
>> ---
>>  drivers/net/ks8851.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ks8851.c b/drivers/net/ks8851.c
>> index 91a93cb..0dc03da 100644
>> --- a/drivers/net/ks8851.c
>> +++ b/drivers/net/ks8851.c
>> @@ -553,7 +553,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>>         for (; rxfc != 0; rxfc--) {
>>                 rxh = ks8851_rdreg32(ks, KS_RXFHSR);
>>                 rxstat = rxh & 0xffff;
>> -               rxlen = rxh >> 16;
>> +               rxlen = (rxh >> 16) & 0xFFF;
>>
>>                 netif_dbg(ks, rx_status, ks->netdev,
>>                           "rx: stat 0x%04x, len 0x%04x\n", rxstat,
> rxlen);
>> --
>> 1.7.10.4
>>
>
>
> ______________________________________________________________________
> This email has been spam and virus checked by Elster IT Services.(See
> attached file: patch.diff)

______________________________________________________________________
This email has been spam and virus checked by Elster IT Services.


