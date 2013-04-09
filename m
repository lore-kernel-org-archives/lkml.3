Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936460Ab3DIVnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:43:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:21675 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934470Ab3DIVnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:43:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,441,1363158000"; 
   d="scan'208";a="283926215"
From: "Gross, Mark" <mark.gross@intel.com>
To: "Cohen, David A" <david.a.cohen@intel.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "dhowells@redhat.com" <dhowells@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] MODSIGN: do not send garbage to stderr when enabling
 modules signature
Thread-Topic: [PATCH v2] MODSIGN: do not send garbage to stderr when
 enabling modules signature
Thread-Index: AQHONWpm8yljXCMlhUqsStjUmzwEFJjOazzg
Date: Tue, 9 Apr 2013 21:43:11 +0000
Message-ID: <BD75D217E5BAC84080F8EFB2582976377175D258@ORSMSX101.amr.corp.intel.com>
References: <1365543543-17522-1-git-send-email-david.a.cohen@intel.com>
In-Reply-To: <1365543543-17522-1-git-send-email-david.a.cohen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r39LhSD2007631

> -----Original Message-----
> From: Cohen, David A
> Sent: Tuesday, April 09, 2013 2:39 PM
> To: rusty@rustcorp.com.au; dhowells@redhat.com
> Cc: linux-kernel@vger.kernel.org; Gross, Mark; Cohen, David A
> Subject: [PATCH v2] MODSIGN: do not send garbage to stderr when enabling
> modules signature
> 
> openssl may send garbage to stderr when generating X.509 key pair for modules
> signature regardless there was an error or not. It makes more difficult to create
> scripts based on kernel error/warning messages.
> 
> When compiling kernel with -jN (N > 1), all warning/error messages printed while
> openssl is generating key pair may get mixed dots and other symbols openssl
> sends to stderr. This patch makes sure openssl logs go to default stdout.
> 
> Example of the garbages:
> 
> crypto/anubis.c:581: warning: â€˜interâ€™ is used uninitialized in this function
> Generating a 4096 bit RSA private key .........
> drivers/gpu/drm/i915/i915_gem_gtt.c: In function â€˜gen6_ggtt_insert_entriesâ€™:
> drivers/gpu/drm/i915/i915_gem_gtt.c:440: warning: â€˜addrâ€™ may be used
> uninitialized in this function
> .net/mac80211/tx.c: In function â€˜ieee80211_subif_start_xmitâ€™:
> net/mac80211/tx.c:1780: warning: â€˜chanctx_confâ€™ may be used uninitialized in
> this function
> ..drivers/isdn/hardware/mISDN/hfcpci.c: In function â€˜hfcpci_softirqâ€™:
> .....drivers/isdn/hardware/mISDN/hfcpci.c:2298: warning: ignoring return value
> of â€˜driver_for_each_deviceâ€™, declared with attribute warn_unused_result
> net/unix/af_unix.c: In function â€˜unix_bindâ€™:
> net/unix/af_unix.c:892: warning: â€˜path.dentryâ€™ may be used uninitialized in this
> function
> net/unix/af_unix.c:892: warning: â€˜path.mntâ€™ may be used uninitialized in this
> function ...++ In file included from drivers/message/i2o/config-osm.c:39:
> drivers/message/i2o/i2o_config.c: In function â€˜i2o_cfg_passthruâ€™:
> drivers/message/i2o/i2o_config.c:888: warning: cast to pointer from integer of
> different size
> drivers/message/i2o/i2o_config.c:943: warning: cast to pointer from integer of
> different size
> drivers/net/ethernet/amd/nmclan_cs.c: In function â€˜nmclan_configâ€™:
> drivers/net/ethernet/amd/nmclan_cs.c:625: warning:
> â€˜pcmcia_request_exclusive_irqâ€™ is deprecated (declared at
> include/pcmcia/ds.h:201)
> drivers/net/ethernet/mellanox/mlx4/mcg.c: In function â€˜find_entryâ€™:
> .....................................................................................................................
> ....................................................................++
> writing new private key to 'signing_key.priv'
> -----
> drivers/net/ethernet/mellanox/mlx4/mcg.c:601: warning: â€˜hashâ€™ may be used
> uninitialized in this function
> 
> Signed-off-by: David Cohen <david.a.cohen@intel.com>
> ---
>  kernel/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/Makefile b/kernel/Makefile index bbde5f1..5a51e6c 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -175,7 +175,7 @@ signing_key.priv signing_key.x509: x509.genkey
>  	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days
> 36500 \
>  		-batch -x509 -config x509.genkey \
>  		-outform DER -out signing_key.x509 \
> -		-keyout signing_key.priv
> +		-keyout signing_key.priv 2>&1
>  	@echo "###"
>  	@echo "### Key pair generated."
>  	@echo "###"
> --
> 1.7.10.4
Reviewed-by: mark gross<mark.gross@intel.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
