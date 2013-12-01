Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3LAX0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 18:26:47 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:55013 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3LAX0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 18:26:46 -0500
Message-ID: <529BC5B0.8010202@gmail.com>
Date: Mon, 02 Dec 2013 01:26:40 +0200
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>,
        Ivaylo DImitrov <ivo.g.dimitrov.75@gmail.com>
CC: omar.ramirez@copitl.com, gregkh@linuxfoundation.org, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] Staging: TIDSPBRIDGE: Remove UUID helper
References: <1385917660-2676-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <1385924770.2664.14.camel@joe-AO722>
In-Reply-To: <1385924770.2664.14.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01.12.2013 21:06, Joe Perches wrote:
> On Sun, 2013-12-01 at 19:07 +0200, Ivaylo DImitrov wrote:
>> From: Ivaylo Dimitrov <freemangordon@abv.bg>
>>
>> Custom uuid helper function is needed only in rmgr/dbdcd.c and doesn't
>> need to be exported. It can also be made way simpler by using sscanf.
> []
>> diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
> []
>> @@ -74,6 +74,40 @@ static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
>>   				   enum nldr_phase phase);
>>   
>>   /*
>> + *  ======== dcd_uuid_from_string ========
>> + *  Purpose:
>> + *      Converts an ANSI string to a dsp_uuid.
>> + *  Parameters:
>> + *      sz_uuid:    Pointer to a string that represents a dsp_uuid object.
>> + *      uuid_obj:      Pointer to a dsp_uuid object.
>> + *  Returns:
>> + *  Requires:
>> + *      uuid_obj & sz_uuid are non-NULL values.
>> + *  Ensures:
>> + *  Details:
>> + *      We assume the string representation of a UUID has the following format:
>> + *      "12345678_1234_1234_1234_123456789abc".
>> + */
>> +static void dcd_uuid_from_string(char *sz_uuid, struct dsp_uuid *uuid_obj)
>> +{
>> +	char c;
>> +	u64 t;
>> +
>> +	/*
>> +	 * sscanf implementation cannot deal with hh format modifier
>> +	 * if the converted value doesn't fit in u32. So, convert the
>> +	 * last six bytes to u64 and memcpy what is needed
>> +	 */
>> +	sscanf(sz_uuid, "%8x%c%4hx%c%4hx%c%2hhx%2hhx%c%llx",
>> +	       &uuid_obj->data1, &c, &uuid_obj->data2, &c,
>> +	       &uuid_obj->data3, &c, &uuid_obj->data4,
>> +	       &uuid_obj->data5, &c, &t);
>> +
>> +	t = cpu_to_be64(t);
>> +	memcpy(&uuid_obj->data6[0], ((char*)&t) + 2, 6);
>> +}
> It'd probably be better to return true or false on
> successful conversion, use a temporary struct dsp_uuid,
> check the sscanf return is 10 and only copy to uuid_obj
> on success.
>
> Something like:
>
> static bool dcd_uuid_from_string(char *sz_uuid, struct dsp_uuid *uuid_obj)
> {
> 	char c;
> 	u64 t;
> 	struct dsp_uuid tmp;
>
> 	/*
> 	 * sscanf implementation cannot deal with hh format modifier
> 	 * if the converted value doesn't fit in u32. So, convert the
> 	 * last six bytes to u64 and memcpy what is needed
> 	 */
> 	if (sscanf(sz_uuid, "%8x%c%4hx%c%4hx%c%2hhx%2hhx%c%llx",
> 		   &tmp.data1, &c, &tmp.data2, &c,
> 		   &tmp.data3, &c, &tmp.data4,
> 		   &tmp.data5, &c, &t) != 10)
> 		return false;
>
> 	t = cpu_to_be64(t);
> 	memcpy(&tmp.data6[0], ((char*)&t) + 2, 6);
> 	*uuid_obj =  tmp;
>
> 	return true;
> }
>
>
If there is to be a return value from that function, it is better to be 
int (-EINVAL/0), IMO. And I am not sure that makes much of a sense, as 
(afaik) uuids are read from baseimage.dof and codec nodes, if those are 
broken I suspect wrong uuids will be our least problem.
