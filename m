Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbaIEPdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:33:13 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:59718 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaIEPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:33:12 -0400
MIME-Version: 1.0
In-Reply-To: <5409C3C6.90204@linux.vnet.ibm.com>
References: <1409908577-10648-1-git-send-email-bharata.rao@gmail.com>
	<5409C3C6.90204@linux.vnet.ibm.com>
Date: Fri, 5 Sep 2014 21:03:11 +0530
Message-ID: <CAGZKiBpFoB2UrCPsEMHS-cJ-ffn1D7zcfznfp+P_gOGsigCPyg@mail.gmail.com>
Subject: Re: [PATCH] pseries: Make CPU hotplug path endian safe
From: Bharata B Rao <bharata.rao@gmail.com>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 7:38 PM, Nathan Fontenot
<nfont@linux.vnet.ibm.com> wrote:
> On 09/05/2014 04:16 AM, bharata.rao@gmail.com wrote:
>> From: Bharata B Rao <bharata@linux.vnet.ibm.com>
>>
>> - ibm,rtas-configure-connector should treat the RTAS data as big endian.
>> - Treat ibm,ppc-interrupt-server#s as big-endian when setting
>>   smp_processor_id during hotplug.
>>
>> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/platforms/pseries/dlpar.c       | 10 +++++-----
>>  arch/powerpc/platforms/pseries/hotplug-cpu.c |  4 ++--
>>  2 files changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
>> index 2d0b4d6..dc55f9c 100644
>> --- a/arch/powerpc/platforms/pseries/dlpar.c
>> +++ b/arch/powerpc/platforms/pseries/dlpar.c
>> @@ -48,11 +48,11 @@ static struct property *dlpar_parse_cc_property(struct cc_workarea *ccwa)
>>       if (!prop)
>>               return NULL;
>>
>> -     name = (char *)ccwa + ccwa->name_offset;
>> +     name = (char *)ccwa + be32_to_cpu(ccwa->name_offset);
>>       prop->name = kstrdup(name, GFP_KERNEL);
>>
>> -     prop->length = ccwa->prop_length;
>> -     value = (char *)ccwa + ccwa->prop_offset;
>> +     prop->length = be32_to_cpu(ccwa->prop_length);
>> +     value = (char *)ccwa + be32_to_cpu(ccwa->prop_offset);
>>       prop->value = kmemdup(value, prop->length, GFP_KERNEL);
>>       if (!prop->value) {
>>               dlpar_free_cc_property(prop);
>> @@ -78,7 +78,7 @@ static struct device_node *dlpar_parse_cc_node(struct cc_workarea *ccwa,
>>       if (!dn)
>>               return NULL;
>>
>> -     name = (char *)ccwa + ccwa->name_offset;
>> +     name = (char *)ccwa + be32_to_cpu(ccwa->name_offset);
>>       dn->full_name = kasprintf(GFP_KERNEL, "%s/%s", path, name);
>>       if (!dn->full_name) {
>>               kfree(dn);
>> @@ -148,7 +148,7 @@ struct device_node *dlpar_configure_connector(u32 drc_index,
>>               return NULL;
>>
>>       ccwa = (struct cc_workarea *)&data_buf[0];
>> -     ccwa->drc_index = drc_index;
>> +     ccwa->drc_index = cpu_to_be32(drc_index);
>
> I need to look at this some more but I think this may cause an issue for
> partition migration. If I am following the code correctly, starting in
> pseries_devicetree_update(), the drc_index value passed to
> dlpar_configure_connector is pulled directly out of a buffer we get from
> firmware. This would mean the drc_index value is already in BE format.

Yes I see that now.

>
> Whereas for cpu hotplug the drc_index value is passed in from userspace
> via the cpu probe interface in sysfs. I assume that you are seeing the
> drc_index value getting passed in in LE format.

Yes I am seeing drc_index in LE format for an LE guest during CPU
hotplug operation.

Regards,
Bharata.
