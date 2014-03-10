Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaCJMx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:53:27 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:18438
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753756AbaCJMxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:53:25 -0400
From: =?utf-8?B?U8O4cmVuc2VuLCBTdGVmYW4=?= 
	<Stefan.Sorensen@spectralink.com>
To: "richardcochran@gmail.com" <richardcochran@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v1 1/9] ptp: introduce programmable pins.
Thread-Topic: [PATCH RFC net-next v1 1/9] ptp: introduce programmable pins.
Thread-Index: AQHPOwacFOeHo3KKh0uQ7OEMH5Gd55raSVKA
Date: Mon, 10 Mar 2014 12:53:09 +0000
Message-ID: <1394455989.2296.23.camel@e37108.spectralink.com>
References: <cover.1394307303.git.richardcochran@gmail.com>
	 <d9cb37a7d6e57d7f103dab78f98044697d3c4433.1394307304.git.richardcochran@gmail.com>
In-Reply-To: <d9cb37a7d6e57d7f103dab78f98044697d3c4433.1394307304.git.richardcochran@gmail.com>
Accept-Language: en-GB, de-DE, da-DK, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
x-originating-ip: [93.166.232.46]
x-forefront-prvs: 014617085B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(189002)(199002)(24454002)(88136002)(50986001)(93136001)(49866001)(74366001)(4396001)(86362001)(97186001)(94316002)(47976001)(95666003)(97336001)(63696002)(31966008)(93516002)(94946001)(46102001)(85306002)(92726001)(74662001)(74502001)(87266001)(87286001)(47446002)(93916002)(65816001)(50226001)(69226001)(92566001)(59766001)(81686001)(66066001)(47736001)(80022001)(77982001)(76796001)(33646001)(89996001)(80976001)(56776001)(1411001)(74876001)(53806001)(51856001)(87936001)(81342001)(95416001)(76786001)(77156001)(83322001)(56816005)(90146001)(62966002)(74706001)(79102001)(76482001)(77096001)(54316002)(85852003)(83072002)(85182001)(81816001)(81542001)(85202002)(2656002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR07MB461;H:DM2PR07MB334.namprd07.prod.outlook.com;CLIP:93.166.232.46;FPR:E461E550.A2159E1A.8BFB3F6F.42E93B61.20248;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <205B8AA711C97A4091795D81D143D283@namprd07.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: spectralink.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2ACrtBo016699

On Sat, 2014-03-08 at 20:42 +0100, Richard Cochran wrote:

>+int ptp_setpin(struct ptp_clock *ptp, unsigned int pin,
>+               enum ptp_pin_function func, unsigned int chan)

>From the name I would think that this would set the state of the pin.
Rename to ptp_set_pinfunc?

> +int ptp_find_pin(struct ptp_clock *ptp,
> +		 enum ptp_pin_function func, unsigned int chan)
> +{
> +	struct ptp_pin_desc *pin = NULL;
> +	int i;
> +
> +	mutex_lock(&ptp->pincfg_mux);
> +	for (i = 0; i < ptp->info->n_pins; i++) {
> +		if (ptp->info->pin_config[i].func == func &&
> +		    ptp->info->pin_config[i].chan == chan) {
> +			pin = &ptp->info->pin_config[i];
> +			break;
> +		}
> +	}
> +	mutex_unlock(&ptp->pincfg_mux);
> +
> +	return pin ? pin - ptp->info->pin_config : -1;
> +}

Maybe replace 'pin - ptp->info->pin_config' with 'i'?

> +++ b/drivers/ptp/ptp_private.h
> @@ -48,6 +48,7 @@ struct ptp_clock {
>  	long dialed_frequency; /* remembers the frequency adjustment */
>  	struct timestamp_event_queue tsevq; /* simple fifo for time stamps */
>  	struct mutex tsevq_mux; /* one process at a time reading the fifo */
> +	struct mutex pincfg_mux; /* protect concurrent info->pin_config access */

Line over 80 chars. 

> + * @setpin:   Confirm that a pin can perform a given function. The PTP
> + *            Hardware Clock subsystem maintains the 'pin_config'
> + *            array on behalf of the drivers, but the PHC subsystem
> + *            assumes that every pin can perform every function. This
> + *            hook gives drivers a way of telling the core about
> + *            limitations on specific pins. This function must return
> + *            zero if the function can be assigned to this pin, and
> + *            nonzero otherwise.

The function does not actually set the pin. Rename to verify_pinfunc?

Stefan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
