Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaBCRN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:13:27 -0500
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:36295 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949AbaBCRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:13:26 -0500
Message-ID: <52EFCE31.7010900@overkiz.com>
Date: Mon, 03 Feb 2014 18:13:21 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] at91: pmc: Fixed irq's name allocation for programmable
 clocks
References: <1391445961-20755-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1391445961-20755-1-git-send-email-jjhiblot@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14860471397466208345
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrjeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello JJ,

On 03/02/2014 17:46, Jean-Jacques Hiblot wrote:
> The name provided to request_irq() must be valid until the irq is
> released.
> This patch allocates and formats the string with kasprintf().

Thanks for reporting this bug.

>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>   drivers/clk/at91/clk-programmable.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
> index 8e242c7..0f8bf0f 100644
> --- a/drivers/clk/at91/clk-programmable.c
> +++ b/drivers/clk/at91/clk-programmable.c
> @@ -19,6 +19,7 @@
>   #include <linux/sched.h>
>   #include <linux/interrupt.h>
>   #include <linux/irq.h>
> +#include <linux/string.h>
>   
>   #include "pmc.h"
>   
> @@ -247,7 +248,7 @@ at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
>   	struct clk_programmable *prog;
>   	struct clk *clk = NULL;
>   	struct clk_init_data init;
> -	char irq_name[11];
> +	char *irq_name;
>   
>   	if (id > PROG_ID_MAX)
>   		return ERR_PTR(-EINVAL);
> @@ -269,7 +270,7 @@ at91_clk_register_programmable(struct at91_pmc *pmc, unsigned int irq,
>   	prog->irq = irq;
>   	init_waitqueue_head(&prog->wait);
>   	irq_set_status_flags(prog->irq, IRQ_NOAUTOEN);
> -	snprintf(irq_name, sizeof(irq_name), "clk-prog%d", id);
> +	irq_name = kasprintf(GFP_KERNEL, "clk-prog%d", id);

Could you either use a static table with the prog clk names or store the 
name in
the clk_programmable struct ?
This way we could avoid the additional dynamic allocation.

static prog_clk_names = {
   "clk-prog0",
[...]
   "clk-prog7",
};

[...]
     ret = request_irq(prog->irq, clk_programmable_irq_handler, 
IRQF_TRIGGER_HIGH, prog_clk_names[id], prog);


or

struct clk_programmable {
[...]
     char irq_name[11];
[...]
};

[...]

snprintf(prog->irq_name, sizeof(prog->irq_name), "clk-prog%d", id);
ret = request_irq(prog->irq, clk_programmable_irq_handler, 
IRQF_TRIGGER_HIGH, prog->irq_name, prog);

Best Regards,

Boris
>   	ret = request_irq(prog->irq, clk_programmable_irq_handler,
>   			  IRQF_TRIGGER_HIGH, irq_name, prog);
>   	if (ret)

