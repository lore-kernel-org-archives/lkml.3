Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbaJGOab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:30:31 -0400
Received: from mail-bn1on0077.outbound.protection.outlook.com ([157.56.110.77]:62818
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752368AbaJGOaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:30:30 -0400
X-Greylist: delayed 5604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2014 10:30:29 EDT
Message-ID: <5433DFC0.705@analog.com>
Date: Tue, 7 Oct 2014 14:42:40 +0200
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Pramod Gurav <pramod.gurav@smartplayin.com>,
        <linux-kernel@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>
Subject: Re: [PATCH] Input: adp5588-keys: cancel workqueue in failure path
References: <1412667049-6128-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1412667049-6128-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:137.71.25.57;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(479174003)(189002)(199003)(24454002)(86362001)(85306004)(64126003)(21056001)(20776003)(47776003)(107046002)(46102003)(23746002)(65956001)(76176999)(64706001)(65806001)(80022003)(54356999)(50986999)(53806999)(19580395003)(65816999)(36756003)(87936001)(19580405001)(44976005)(6806004)(102836001)(76482002)(99396003)(50466002)(33656002)(120916001)(85852003)(92726001)(4396001)(43066003)(95666004)(106466001)(83506001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB0863;H:nwd2mta2.analog.com;FPR:;MLV:sfv;PTR:nwd2mail11.analog.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0863;
X-Forefront-PRVS: 035748864E
Authentication-Results: spf=pass (sender IP is 137.71.25.57)
 smtp.mailfrom=Michael.Hennerich@analog.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1182;
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 09:30 AM, Pramod Gurav wrote:
> This change introduces a label to call cancel_delayed_work_sync in
> failure path.
>
> Cc: Michael Hennerich <michael.hennerich@analog.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

The interrupt triggers the work queue. adp5588_setup() enable the HW 
interrupt.
Only if the device was configured before, without being resetb -
The earliest point in time where a problem could happen - is after the 
request_irq().

Anyways patch below doesn't harm and fixes a potential problem.

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>   drivers/input/keyboard/adp5588-keys.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
> index 5ef7fcf..b494062 100644
> --- a/drivers/input/keyboard/adp5588-keys.c
> +++ b/drivers/input/keyboard/adp5588-keys.c
> @@ -559,7 +559,7 @@ static int adp5588_probe(struct i2c_client *client,
>   	error = input_register_device(input);
>   	if (error) {
>   		dev_err(&client->dev, "unable to register input device\n");
> -		goto err_free_mem;
> +		goto err_delayed_work;
>   	}
>   
>   	error = request_irq(client->irq, adp5588_irq,
> @@ -592,6 +592,8 @@ static int adp5588_probe(struct i2c_client *client,
>    err_unreg_dev:
>   	input_unregister_device(input);
>   	input = NULL;
> + err_delayed_work:
> +	cancel_delayed_work_sync(&kpad->work);
>    err_free_mem:
>   	input_free_device(input);
>   	kfree(kpad);


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif

