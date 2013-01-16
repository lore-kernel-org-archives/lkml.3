Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3APOfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:35:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35067 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3APOf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:35:29 -0500
Message-ID: <50F6BA8C.1070709@canonical.com>
Date: Wed, 16 Jan 2013 15:34:52 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Andre Przywara <andre@andrep.de>,
        xen-devel <xen-devel@lists.xen.org>, Matthew Garrett <mjg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] kernel 3.7+ cpufreq regression on AMD system running
 as dom0
References: <50F42B3E.7090602@canonical.com> <20130114163445.GA4867@liondog.tnic> <20130115175305.GA12449@phenom.dumpdata.com> <50F68E4902000078000B61AC@nat28.tlf.novell.com>
In-Reply-To: <50F68E4902000078000B61AC@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 11:26 AM, Jan Beulich wrote:
>>>> On 15.01.13 at 18:53, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> On Mon, Jan 14, 2013 at 05:34:45PM +0100, Borislav Petkov wrote:
>>> On Mon, Jan 14, 2013 at 04:58:54PM +0100, Stefan Bader wrote:
>>>> --- a/drivers/acpi/processor_perflib.c
>>>> +++ b/drivers/acpi/processor_perflib.c
>>>> @@ -340,6 +340,9 @@ static void amd_fixup_frequency(struct acpi_processor_px *px
>>>>          if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
>>>>              || boot_cpu_data.x86 == 0x11) {
>>>>                  rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
>>>> +               /* Bit 63 indicates whether contents are valid */
>>>> +               if (!(hi & 0x8000000))
>>>> +                       return;
>>>
>>> I don't think that's the right change - this is fixing baremetal so that
>>> it works on xen. And besides, this code was in powernow-k8 before so I'm
>>> wondering why did it work then.
>>
>> Powernow-k8 only populated the cpufreq policy information. This library
>> (processor_perflib) is the generic library used for ACPI P-states parsing.
>> This specific function (acpi_processor_get_performance_states) is just
>> used to fetch and parse the P-states.
>>
>> Xen-acpi-processor (which we use to upload the P and C-states to the
>> hypervisor) ends up calling this library to parse the P-states
>> and this unfortunate quirk clamps the P-states based on the MSRS.
>>
>> It is odd that this CPU specific quirk got added in this generic
>> library. Is there no ACPI quirk system similar to how DMI quirks
>> are handled?
>>
>> Anyhow, I think this patch makes sense - it makes sure that the
>> MSR value is sane.
>>
>> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> Did someone actually _test_ that patch? I ask because the mask
> used (0x8000000) doesn't check bit 63 as the comment says, but
> bit 59 instead...
>
> Jan
>
Not this version which I did at the end of a day to have a cleaned up version to 
discuss. And obviously I managed to get the number of zeros wrong. :(

The comment is right and it should be 0x80000000
