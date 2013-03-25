Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3CYPlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:41:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61995 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab3CYPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:41:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/3] mfd: db8500-prcmu: Fetch the PRCMU TCDM base address from Device Tree
Date: Mon, 25 Mar 2013 15:40:50 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1364223758-17621-1-git-send-email-lee.jones@linaro.org> <1364223758-17621-2-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1364223758-17621-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251540.51104.arnd@arndb.de>
X-Provags-ID: V02:K0:66l1pnHHoPBAHMx9RAiopiFvAlFdLm0uBQoeabw0ZWX
 L6MRmqhrm5hTU8E8z/tiheCQNmK2bEg8lUOj9hH9sKsqAkRnri
 Wo1DlxiMTt1o5IJXi5/KQwFasveKQ07X45Ao8FmuDTO6236wXT
 Ggoc6S9eEgZost4UNr+1D1oawePvlbI6Yw/GHAww2pPk8GUWJk
 ajL8xhalBl9KpoTpjCJQxEKGCdBa0r1S362WnOhQ9kIRwemW47
 pdAyaCsiKetLwr25qNr4TcP0S8eeb/c7jUHWHlM1ZOlGVdxUVZ
 5xo9a2WE5knZW1QeNU2/LtRadFcYinTrTEoSIeNVsoH2WY+dzf
 TztUg+VWnjKNkp+g0LDU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, Lee Jones wrote:
>         res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>                                            "prcmu-tcpm");
>         if (!res) {
> -               dev_err(&pdev->dev,
> -                       "Error: no prcmu tcpm memory region provided\n");
> -               return;
> -       }
> -       tcpm_base = ioremap(res->start, resource_size(res));
> +               if (np) {
> +                       tcpm_np = of_find_node_by_name(np->parent,
> +                                                      "prcmu-tcpm-per4");
> +                       if (!tcpm_np) {
> +                               dev_err(&pdev->dev,
> +                                       "no prcmu tcpm mem region provided\n");
> +                               return;
> +                       }
> +                       tcpm_base = of_iomap(tcpm_np, 0);
> +               }
> +       } else
> +               tcpm_base = ioremap(res->start, resource_size(res));
> +

Why don't you just add these extra registers to the prcmu node itself like

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 9de9309..6ee6c31 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -191,8 +191,8 @@
 
 		prcmu: prcmu@80157000 {
 			compatible = "stericsson,db8500-prcmu";
-			reg = <0x80157000 0x1000>;
-			reg-names = "prcmu";
+			reg = <0x80157000 0x1000>, <0x801b0000 0x1000>, <0x801b8000 0x1000>;
+			reg-names = "prcmu", "prcmu-tcpm", "prcmu-tcdm-per4";
 			interrupts = <0 47 0x4>;
 			#address-cells = <1>;
 			#size-cells = <1>;


and document those in the prcmu binding?

That would keep the code simpler and the same for both cases.

	Arnd
