Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab3IWRHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab3IWRHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:07:14 -0400
Date: Mon, 23 Sep 2013 14:06:48 -0300
From: Eduardo Habkost <ehabkost@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre@andrep.de>,
        Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        libvir-list@redhat.com, Jiri Denemark <jdenemar@redhat.com>
Subject: Re: [PATCH 6/6] qemu: Add support for emulated CPU features
Message-ID: <20130923170648.GD7264@otherpad.lan.raisama.net>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
 <1379861095-628-7-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379861095-628-7-git-send-email-bp@alien8.de>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing qemu-devel and libvir-list)

On Sun, Sep 22, 2013 at 04:44:55PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Add support for the KVM_GET_EMULATED_CPUID ioctl and leave feature bits
> enabled, when requested by userspace, if kvm emulates them.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>

This will break some assumptions about the semantics of "-cpu host",
that today means "enable every single feature that can be enabled in the
host". This, in turn, breaks the assumption that "-cpu host" can be used
by libvirt to get information about all CPU features supported by the
host.

So, I have two questions:

1) Should "-cpu host" enable GET_EMULATED_CPUID features? (I believe the
   answer is "no");
2) If not, we need a new mechanism to let libvirt know which features
   can be enabled on a host (in a way that would allow libvirt to
   easily calculate the set of possible destination hosts to which a VM
   can be migrated, before deciding to migrate it).

This interface is getting complex enough for me to consider simply
asking libvirt developers to call GET_EMULATED_CPUID and
GET_SUPPORTED_CPUID directly, instead of asking QEMU for information.
But if libvirt does that, it needs a way to know if it's running a QEMU
version that supports GET_EMULATED_CPUID, or an old version that
supports only GET_SUPPORTED_CPUID.

Another alternative is to simply let libvirt ignore GET_EMULATED_CPUID
by now, and treat GET_EMULATED_CPUID features as not supported by the
host. But then it will break the use cases that prompted the creation of
GET_EMULATED_CPUID in the first place.

> ---
>  include/sysemu/kvm.h      |  4 ++++
>  linux-headers/linux/kvm.h |  4 ++++
>  target-i386/cpu.c         |  7 +++++++
>  target-i386/kvm.c         | 38 ++++++++++++++++++++++++++++++++++----
>  4 files changed, 49 insertions(+), 4 deletions(-)
> 
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 9bbe3db1464e..8eda1ada848a 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -265,6 +265,10 @@ int kvm_check_extension(KVMState *s, unsigned int extension);
>  
>  uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
>                                        uint32_t index, int reg);
> +
> +uint32_t kvm_arch_get_emulated_cpuid(KVMState *env, uint32_t function,
> +                                     uint32_t index, int reg);
> +
>  void kvm_cpu_synchronize_state(CPUState *cpu);
>  
>  /* generic hooks - to be moved/refactored once there are more users */
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index c614070662e1..edc8f2db1f8d 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -541,6 +541,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_TRACE_ENABLE          __KVM_DEPRECATED_MAIN_W_0x06
>  #define KVM_TRACE_PAUSE           __KVM_DEPRECATED_MAIN_0x07
>  #define KVM_TRACE_DISABLE         __KVM_DEPRECATED_MAIN_0x08
> +#define KVM_GET_EMULATED_CPUID    _IOWR(KVMIO, 0x09, struct kvm_cpuid2)
>  
>  /*
>   * Extension capability list.
> @@ -666,6 +667,9 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_IRQ_MPIC 90
>  #define KVM_CAP_PPC_RTAS 91
>  #define KVM_CAP_IRQ_XICS 92
> +#define KVM_CAP_ARM_EL1_32BIT 93
> +#define KVM_CAP_SPAPR_MULTITCE 94
> +#define KVM_CAP_EXT_EMUL_CPUID 95
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> diff --git a/target-i386/cpu.c b/target-i386/cpu.c
> index c36345e426d7..5406348ceb4a 100644
> --- a/target-i386/cpu.c
> +++ b/target-i386/cpu.c
> @@ -1850,7 +1850,14 @@ static void filter_features_for_kvm(X86CPU *cpu)
>                                                               wi->cpuid_ecx,
>                                                               wi->cpuid_reg);
>          uint32_t requested_features = env->features[w];
> +
> +        uint32_t emul_features = kvm_arch_get_emulated_cpuid(s, wi->cpuid_eax,
> +                                                                wi->cpuid_ecx,
> +                                                                wi->cpuid_reg);
> +
>          env->features[w] &= host_feat;
> +        env->features[w] |= (requested_features & emul_features);
> +

I find the above logic confusing: you remove a few bits just to re-add
them later. Isn't easier and simpler to simply do:
    env->features[w] &= (host_feat | emul_features);
?

>          cpu->filtered_features[w] = requested_features & ~env->features[w];
>      }
>  }
> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> index 749aa09a21a6..7f598f01bda5 100644
> --- a/target-i386/kvm.c
> +++ b/target-i386/kvm.c
> @@ -80,7 +80,7 @@ bool kvm_allows_irq0_override(void)
>      return !kvm_irqchip_in_kernel() || kvm_has_gsi_routing();
>  }
>  
> -static struct kvm_cpuid2 *try_get_cpuid(KVMState *s, int max)
> +static struct kvm_cpuid2 *try_get_cpuid(KVMState *s, int ioctl, int max)
>  {
>      struct kvm_cpuid2 *cpuid;
>      int r, size;
> @@ -88,7 +88,7 @@ static struct kvm_cpuid2 *try_get_cpuid(KVMState *s, int max)
>      size = sizeof(*cpuid) + max * sizeof(*cpuid->entries);
>      cpuid = (struct kvm_cpuid2 *)g_malloc0(size);
>      cpuid->nent = max;
> -    r = kvm_ioctl(s, KVM_GET_SUPPORTED_CPUID, cpuid);
> +    r = kvm_ioctl(s, ioctl, cpuid);
>      if (r == 0 && cpuid->nent >= max) {
>          r = -E2BIG;
>      }
> @@ -97,7 +97,10 @@ static struct kvm_cpuid2 *try_get_cpuid(KVMState *s, int max)
>              g_free(cpuid);
>              return NULL;
>          } else {
> -            fprintf(stderr, "KVM_GET_SUPPORTED_CPUID failed: %s\n",
> +            fprintf(stderr, "%s failed: %s\n",
> +                    (ioctl == (int)KVM_GET_SUPPORTED_CPUID
> +                     ? "KVM_GET_SUPPORTED_CPUID"
> +                     : "KVM_GET_EMULATED_CPUID"),
>                      strerror(-r));
>              exit(1);
>          }
> @@ -112,7 +115,17 @@ static struct kvm_cpuid2 *get_supported_cpuid(KVMState *s)
>  {
>      struct kvm_cpuid2 *cpuid;
>      int max = 1;
> -    while ((cpuid = try_get_cpuid(s, max)) == NULL) {
> +    while ((cpuid = try_get_cpuid(s, KVM_GET_SUPPORTED_CPUID, max)) == NULL) {
> +        max *= 2;
> +    }
> +    return cpuid;
> +}
> +
> +static struct kvm_cpuid2 *get_emulated_cpuid(KVMState *s)
> +{
> +    struct kvm_cpuid2 *cpuid;
> +    int max = 1;
> +    while ((cpuid = try_get_cpuid(s, KVM_GET_EMULATED_CPUID, max)) == NULL) {
>          max *= 2;
>      }
>      return cpuid;
> @@ -241,6 +254,23 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>      return ret;
>  }
>  
> +uint32_t kvm_arch_get_emulated_cpuid(KVMState *s, uint32_t function,
> +                                     uint32_t index, int reg)
> +{
> +    struct kvm_cpuid2 *cpuid __attribute__((unused));
> +
> +    if (!kvm_check_extension(s, KVM_CAP_EXT_EMUL_CPUID))
> +        return 0;
> +
> +    cpuid = get_emulated_cpuid(s);
> +
> +    struct kvm_cpuid_entry2 *entry = cpuid_find_entry(cpuid, function, index);
> +    if (entry)
> +        return cpuid_entry_get_reg(entry, reg);
> +
> +    return 0;
> +}
> +
>  typedef struct HWPoisonPage {
>      ram_addr_t ram_addr;
>      QLIST_ENTRY(HWPoisonPage) list;
> -- 
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Eduardo
