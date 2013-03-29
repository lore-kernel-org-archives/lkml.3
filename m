Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab3C2NW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:22:57 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.5]:40446 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702Ab3C2NWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:22:55 -0400
X-Env-Sender: Max.Nekludov@us.elster.com
X-Msg-Ref: server-8.tower-142.messagelabs.com!1364563372!6266577!1
X-Originating-IP: [129.179.1.27]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Subject: Fw: Bug in ks8851.c
X-KeepSent: 2DFE75BF:1BA5B9C8-44257B3D:00492A11;
 type=4; name=$KeepSent
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jiri@resnulli.us>,
        linus971@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Renzelmann <mjr@cs.wisc.edu>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Greg Ungerer <gerg@uclinux.org>,
        linux-arm-kernel@lists.infradead.org
X-Mailer: Lotus Notes Release 8.5.2FP3 July 11, 2011
Message-ID: <OF2DFE75BF.1BA5B9C8-ON44257B3D.00492A11-44257B3D.0049472A@gb.elster.com>
From: Max.Nekludov@us.elster.com
Date: Fri, 29 Mar 2013 17:20:23 +0400
X-MIMETrack: Serialize by Router on US-SMTP01.domino.elster-group.com/RIM-TEMP(Release
 8.5.2FP3|July 10, 2011) at 03/29/2013 09:11:04 AM
MIME-Version: 1.0
Content-type: multipart/mixed; 
	Boundary="0__=CBBBF1AEDFDAAC818f9e8a93df938690918cCBBBF1AEDFDAAC81"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0__=CBBBF1AEDFDAAC818f9e8a93df938690918cCBBBF1AEDFDAAC81
Content-type: text/plain; charset=US-ASCII


Linus,

I tried to send the mail to 'Ben Dooks <ben@simtec.co.uk>' but the address
is dead now.
> I assume you've tested it in practice?
Yes, I'm running the modified code both in bootloader and Linux kernel on
my board.

Thanks,
Max

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




Max,
 please cc the actual maintainers of the driver. The patch looks sane,
though. I assume you've tested it in practice?

You also seem to have based this on an ancient version, the code has
long since moved from drivers/net/ks8851.c to
drivers/net/ethernet/micrel/ks8851.c (back in June of 2011), and it's
missing a sign-off from you.

I'm attaching an updated patch for the rename/capitalization issue.

     Linus

On Thu, Mar 28, 2013 at 11:25 AM,  <Max.Nekludov@us.elster.com> wrote:
>
> According to the Datasheet (page 52):
> 15-12 Reserved
> 11-0 RXBC Receive Byte Count
> This field indicates the present received frame byte size.
>
> I suppose the code has a bug:
>                 rxh = ks8851_rdreg32(ks, KS_RXFHSR);
>                 rxstat = rxh & 0xffff;
>                 rxlen = rxh >> 16; // BUG!!! 0xFFF mask should be applied
>
> P.S.
> without bit mask applied I saw rxlen equal to 15360 which is bigger then
> entire RX queue size (12KB).
>
> Thanks,
> Max Nekludov
>
> From cb3199cee4490f98d6062e32a75ca377a32b55bc Mon Sep 17 00:00:00 2001
> From: Max Neklyudov <macscomp@gmail.com>
> Date: Tue, 26 Mar 2013 11:46:57 +0400
> Subject: [PATCH] Fix bug in ks8851 driver
>
> ---
>  drivers/net/ks8851.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ks8851.c b/drivers/net/ks8851.c
> index 91a93cb..0dc03da 100644
> --- a/drivers/net/ks8851.c
> +++ b/drivers/net/ks8851.c
> @@ -553,7 +553,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>         for (; rxfc != 0; rxfc--) {
>                 rxh = ks8851_rdreg32(ks, KS_RXFHSR);
>                 rxstat = rxh & 0xffff;
> -               rxlen = rxh >> 16;
> +               rxlen = (rxh >> 16) & 0xFFF;
>
>                 netif_dbg(ks, rx_status, ks->netdev,
>                           "rx: stat 0x%04x, len 0x%04x\n", rxstat,
rxlen);
> --
> 1.7.10.4
>


______________________________________________________________________
This email has been spam and virus checked by Elster IT Services.(See
attached file: patch.diff)
--0__=CBBBF1AEDFDAAC818f9e8a93df938690918cCBBBF1AEDFDAAC81
Content-type: application/octet-stream; 
	name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-transfer-encoding: base64

IGRyaXZlcnMvbmV0L2V0aGVybmV0L21pY3JlbC9rczg4NTEuYyB8IDIgKy0KIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21pY3JlbC9rczg4NTEuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21pY3Jl
bC9rczg4NTEuYwppbmRleCAzM2JjYjYzZDU2YTIuLjhmYjQ4MTI1MmUyYyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcmVsL2tzODg1MS5jCisrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21pY3JlbC9rczg4NTEuYwpAQCAtNTI4LDcgKzUyOCw3IEBAIHN0YXRpYyB2b2lkIGtz
ODg1MV9yeF9wa3RzKHN0cnVjdCBrczg4NTFfbmV0ICprcykKIAlmb3IgKDsgcnhmYyAhPSAwOyBy
eGZjLS0pIHsKIAkJcnhoID0ga3M4ODUxX3JkcmVnMzIoa3MsIEtTX1JYRkhTUik7CiAJCXJ4c3Rh
dCA9IHJ4aCAmIDB4ZmZmZjsKLQkJcnhsZW4gPSByeGggPj4gMTY7CisJCXJ4bGVuID0gKHJ4aCA+
PiAxNikgJiAweGZmZjsKIAogCQluZXRpZl9kYmcoa3MsIHJ4X3N0YXR1cywga3MtPm5ldGRldiwK
IAkJCSAgInJ4OiBzdGF0IDB4JTA0eCwgbGVuIDB4JTA0eFxuIiwgcnhzdGF0LCByeGxlbik7Cg==

--0__=CBBBF1AEDFDAAC818f9e8a93df938690918cCBBBF1AEDFDAAC81--

