Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3LATGQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 14:06:16 -0500
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:51005 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751770Ab3LATGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 14:06:14 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2736:2828:2914:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:4605:5007:7576:7652:7903:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12663:12679:12740:13101,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rifle30_70608aaa85745
X-Filterd-Recvd-Size: 3406
Message-ID: <1385924770.2664.14.camel@joe-AO722>
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Remove UUID helper
From: Joe Perches <joe@perches.com>
To: Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>
Cc: omar.ramirez@copitl.com, gregkh@linuxfoundation.org, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Date: Sun, 01 Dec 2013 11:06:10 -0800
In-Reply-To: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-01 at 19:07 +0200, Ivaylo DImitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
> 
> Custom uuid helper function is needed only in rmgr/dbdcd.c and doesn't
> need to be exported. It can also be made way simpler by using sscanf.
[]
> diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
[]
> @@ -74,6 +74,40 @@ static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
>  				   enum nldr_phase phase);
>  
>  /*
> + *  ======== dcd_uuid_from_string ========
> + *  Purpose:
> + *      Converts an ANSI string to a dsp_uuid.
> + *  Parameters:
> + *      sz_uuid:    Pointer to a string that represents a dsp_uuid object.
> + *      uuid_obj:      Pointer to a dsp_uuid object.
> + *  Returns:
> + *  Requires:
> + *      uuid_obj & sz_uuid are non-NULL values.
> + *  Ensures:
> + *  Details:
> + *      We assume the string representation of a UUID has the following format:
> + *      "12345678_1234_1234_1234_123456789abc".
> + */
> +static void dcd_uuid_from_string(char *sz_uuid, struct dsp_uuid *uuid_obj)
> +{
> +	char c;
> +	u64 t;
> +
> +	/*
> +	 * sscanf implementation cannot deal with hh format modifier
> +	 * if the converted value doesn't fit in u32. So, convert the
> +	 * last six bytes to u64 and memcpy what is needed
> +	 */
> +	sscanf(sz_uuid, "%8x%c%4hx%c%4hx%c%2hhx%2hhx%c%llx",
> +	       &uuid_obj->data1, &c, &uuid_obj->data2, &c,
> +	       &uuid_obj->data3, &c, &uuid_obj->data4,
> +	       &uuid_obj->data5, &c, &t);
> +
> +	t = cpu_to_be64(t);
> +	memcpy(&uuid_obj->data6[0], ((char*)&t) + 2, 6);
> +}

It'd probably be better to return true or false on
successful conversion, use a temporary struct dsp_uuid,
check the sscanf return is 10 and only copy to uuid_obj
on success.

Something like:

static bool dcd_uuid_from_string(char *sz_uuid, struct dsp_uuid *uuid_obj)
{
	char c;
	u64 t;
	struct dsp_uuid tmp;

	/*
	 * sscanf implementation cannot deal with hh format modifier
	 * if the converted value doesn't fit in u32. So, convert the
	 * last six bytes to u64 and memcpy what is needed
	 */
	if (sscanf(sz_uuid, "%8x%c%4hx%c%4hx%c%2hhx%2hhx%c%llx",
		   &tmp.data1, &c, &tmp.data2, &c,
		   &tmp.data3, &c, &tmp.data4,
		   &tmp.data5, &c, &t) != 10)
		return false;

	t = cpu_to_be64(t);
	memcpy(&tmp.data6[0], ((char*)&t) + 2, 6);
	*uuid_obj =  tmp;

	return true;
}


