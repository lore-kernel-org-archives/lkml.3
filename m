Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3I3JFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:05:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab3I3JFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:05:18 -0400
Message-ID: <52493EC6.4020403@redhat.com>
Date: Mon, 30 Sep 2013 11:05:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Eduardo Habkost <ehabkost@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: qemu, numa: non-contiguous cpusets
References: <20130929151044.GB5426@pd.tnic>
In-Reply-To: <20130929151044.GB5426@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 29/09/2013 17:10, Borislav Petkov ha scritto:
> Btw,
> 
> while I got your attention, on a not-really related topic: how do we
> feel about adding support for specifying a non-contiguous set of cpus
> for a numa node in qemu with the -numa option? I.e., like this, for
> example:
> 
> x86_64-softmmu/qemu-system-x86_64 -smp 8 -numa node,nodeid=0,cpus=0\;2\;4-5 -numa node,nodeid=1,cpus=1\;3\;6-7

I think there are already patches on the list to do that, as part of the
NUMA memory binding series from Wanlong Gao.

Paolo

> The ';' needs to be escaped from the shell but I'm open for better
> suggestions.
> 
> Here's a diff:
> 
> ---
> diff --git a/vl.c b/vl.c
> index 4e709d5c1c20..82a6c8451fb0 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -1261,9 +1261,27 @@ char *get_boot_devices_list(size_t *size)
>      return list;
>  }
>  
> +static int __numa_set_cpus(unsigned long *map, int start, int end)
> +{
> +    if (end >= MAX_CPUMASK_BITS) {
> +        end = MAX_CPUMASK_BITS - 1;
> +        fprintf(stderr,
> +            "qemu: NUMA: A max of %d VCPUs are supported\n",
> +             MAX_CPUMASK_BITS);
> +        return -EINVAL;
> +    }
> +
> +    if (end < start) {
> +        return -EINVAL;
> +    }
> +
> +    bitmap_set(map, start, end-start+1);
> +    return 0;
> +}
> +
>  static void numa_node_parse_cpus(int nodenr, const char *cpus)
>  {
> -    char *endptr;
> +    char *endptr, *ptr = (char *)cpus;
>      unsigned long long value, endvalue;
>  
>      /* Empty CPU range strings will be considered valid, they will simply
> @@ -1273,7 +1291,8 @@ static void numa_node_parse_cpus(int nodenr, const char *cpus)
>          return;
>      }
>  
> -    if (parse_uint(cpus, &value, &endptr, 10) < 0) {
> +fromthetop:
> +    if (parse_uint(ptr, &value, &endptr, 10) < 0) {
>          goto error;
>      }
>      if (*endptr == '-') {
> @@ -1282,22 +1301,22 @@ static void numa_node_parse_cpus(int nodenr, const char *cpus)
>          }
>      } else if (*endptr == '\0') {
>          endvalue = value;
> -    } else {
> -        goto error;
> -    }
> +    } else if (*endptr == ';') {
> +	if (__numa_set_cpus(node_cpumask[nodenr], value, value) < 0) {
> +		goto error;
> +	}
> +	endptr++;
> +        if (*endptr == '\0')
> +	    return;
>  
> -    if (endvalue >= MAX_CPUMASK_BITS) {
> -        endvalue = MAX_CPUMASK_BITS - 1;
> -        fprintf(stderr,
> -            "qemu: NUMA: A max of %d VCPUs are supported\n",
> -             MAX_CPUMASK_BITS);
> -    }
> +	ptr = endptr;
>  
> -    if (endvalue < value) {
> +	goto fromthetop;
> +    } else {
>          goto error;
>      }
>  
> -    bitmap_set(node_cpumask[nodenr], value, endvalue-value+1);
> +    __numa_set_cpus(node_cpumask[nodenr], value, endvalue);
>      return;
>  
>  error:
> --
> 
> Thanks.
> 

