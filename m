Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161030AbaDTDWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 23:22:41 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:56123 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbaDTDWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 23:22:36 -0400
Message-ID: <53533D74.6020004@redhat.com>
Date: Sat, 19 Apr 2014 23:22:28 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Check for host supported fields in shadow vmcs
References: <jpgha5olwq2.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpgha5olwq2.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/04/2014 19:34, Bandan Das ha scritto:
>
> We track shadow vmcs fields through two static lists,
> one for read only fields and another for r/w. However, with
> addition of new vmcs fields, not all fields may be supported on
> all hosts. If so, copy_vmcs12_to_shadow() trying to vmwrite on older
> hosts will result in a vmwrite error. For example, commit
> 36be0b9deb23161 introduced GUEST_BNDCFGS, which is not supported
> for all processors. Create new lists based out of intersection of
> static lists and host support and use them for tracking
> shadow fields instead
>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> ---
>  arch/x86/kvm/vmx.c | 98 +++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 79 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 7bed3e3..ffc2232 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -502,7 +502,10 @@ static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
>  #define FIELD64(number, name)	[number] = VMCS12_OFFSET(name), \
>  				[number##_HIGH] = VMCS12_OFFSET(name)+4
>
> -
> +/*
> + * Do not use the two lists below directly
> + * Use vmcs_shadow_fields instead
> + */
>  static const unsigned long shadow_read_only_fields[] = {
>  	/*
>  	 * We do NOT shadow fields that are modified when L0
> @@ -526,8 +529,6 @@ static const unsigned long shadow_read_only_fields[] = {
>  	GUEST_LINEAR_ADDRESS,
>  	GUEST_PHYSICAL_ADDRESS
>  };
> -static const int max_shadow_read_only_fields =
> -	ARRAY_SIZE(shadow_read_only_fields);
>
>  static const unsigned long shadow_read_write_fields[] = {
>  	GUEST_RIP,
> @@ -558,8 +559,18 @@ static const unsigned long shadow_read_write_fields[] = {
>  	HOST_FS_SELECTOR,
>  	HOST_GS_SELECTOR
>  };
> -static const int max_shadow_read_write_fields =
> -	ARRAY_SIZE(shadow_read_write_fields);

Can we just remove the "const" here, and compress the arrays down 
similar to what kvm_init_msr_list does.

> +/* If new shadow fields are added, these should be modified appropriately */
> +#define VMCS_MAX_RO_FIELDS 10
> +#define VMCS_MAX_RW_FIELDS 30
> +
> +struct vmcs_shadow_fields_data {
> +	int shadow_ro_fields_len;
> +	int shadow_rw_fields_len;
> +	unsigned long shadow_read_only_fields[VMCS_MAX_RO_FIELDS];
> +	unsigned long shadow_read_write_fields[VMCS_MAX_RW_FIELDS];
> +};
> +static struct vmcs_shadow_fields_data vmcs_shadow_fields;
>
>  static const unsigned short vmcs_field_to_offset_table[] = {
>  	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
> @@ -3027,6 +3038,56 @@ static __init int alloc_kvm_area(void)
>  	return 0;
>  }
>
> +static void cleanup_vmcs_shadow_fields(void)
> +{
> +	memset(&vmcs_shadow_fields, 0,
> +	       sizeof(struct vmcs_shadow_fields_data));
> +}
> +
> +static void init_vmcs_shadow_fields(void)
> +{
> +	struct vmcs_shadow_fields_data *vmcs_ptr = &vmcs_shadow_fields;
> +	int max_shadow_read_write_fields = ARRAY_SIZE(shadow_read_write_fields);
> +	int max_shadow_read_only_fields = ARRAY_SIZE(shadow_read_only_fields);
> +	int i, j;
> +
> +	for (i = 0, j = 0; i < max_shadow_read_write_fields; i++) {
> +		if (i >= VMCS_MAX_RW_FIELDS) {
> +			WARN(1, "Shadow RW fields index out of bounds\n");
> +			break;
> +		}
> +		if ((shadow_read_write_fields[i] == GUEST_BNDCFGS) &&
> +		    !vmx_mpx_supported())
> +			continue;

Please code this as a "switch" statement for easier future 
extensibility.  Again, this would be similar to kvm_init_msr_list.

How did you find this?  Do you have access to a machine with shadow 
VMCS?  Is that Ivy Bridge Xeon E5 or does some lower-end Haswell have it?

Paolo

> +		vmcs_ptr->shadow_read_write_fields[j++] =
> +			shadow_read_write_fields[i];
> +		vmcs_ptr->shadow_rw_fields_len++;
> +	}
> +
> +	for (i = 0, j = 0; i < max_shadow_read_only_fields; i++) {
> +		if (i >= VMCS_MAX_RO_FIELDS) {
> +			WARN(1, "Shadow RO fields index out of bounds\n");
> +			break;
> +		}
> +		vmcs_ptr->shadow_read_only_fields[j++] =
> +			shadow_read_only_fields[i];
> +		vmcs_ptr->shadow_ro_fields_len++;
> +	}
> +
> +	/* shadowed read/write fields */
> +	for (i = 0; i < vmcs_ptr->shadow_rw_fields_len; i++) {
> +		clear_bit(vmcs_ptr->shadow_read_write_fields[i],
> +			  vmx_vmwrite_bitmap);
> +		clear_bit(vmcs_ptr->shadow_read_write_fields[i],
> +			  vmx_vmread_bitmap);
> +	}
> +	/* shadowed read only fields */
> +	for (i = 0; i < vmcs_ptr->shadow_ro_fields_len; i++)
> +		clear_bit(vmcs_ptr->shadow_read_only_fields[i],
> +			  vmx_vmread_bitmap);
> +
> +}
> +
>  static __init int hardware_setup(void)
>  {
>  	if (setup_vmcs_config(&vmcs_config) < 0)
> @@ -3039,6 +3100,8 @@ static __init int hardware_setup(void)
>  		enable_vpid = 0;
>  	if (!cpu_has_vmx_shadow_vmcs())
>  		enable_shadow_vmcs = 0;
> +	if (enable_shadow_vmcs)
> +		init_vmcs_shadow_fields();
>
>  	if (!cpu_has_vmx_ept() ||
>  	    !cpu_has_vmx_ept_4levels()) {
> @@ -3084,6 +3147,8 @@ static __init int hardware_setup(void)
>
>  static __exit void hardware_unsetup(void)
>  {
> +	if (enable_shadow_vmcs)
> +		cleanup_vmcs_shadow_fields();
>  	free_kvm_area();
>  }
>
> @@ -6159,8 +6224,9 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
>  	unsigned long field;
>  	u64 field_value;
>  	struct vmcs *shadow_vmcs = vmx->nested.current_shadow_vmcs;
> -	const unsigned long *fields = shadow_read_write_fields;
> -	const int num_fields = max_shadow_read_write_fields;
> +	const unsigned long *fields =
> +		vmcs_shadow_fields.shadow_read_write_fields;
> +	const int num_fields = vmcs_shadow_fields.shadow_rw_fields_len;
>
>  	vmcs_load(shadow_vmcs);
>
> @@ -6189,13 +6255,15 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
>
>  static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
>  {
> +	struct vmcs_shadow_fields_data *ptr = &vmcs_shadow_fields;
> +
>  	const unsigned long *fields[] = {
> -		shadow_read_write_fields,
> -		shadow_read_only_fields
> +		ptr->shadow_read_write_fields,
> +		ptr->shadow_read_only_fields
>  	};
>  	const int max_fields[] = {
> -		max_shadow_read_write_fields,
> -		max_shadow_read_only_fields
> +		ptr->shadow_rw_fields_len,
> +		ptr->shadow_ro_fields_len
>  	};
>  	int i, q;
>  	unsigned long field;
> @@ -8817,14 +8885,6 @@ static int __init vmx_init(void)
>
>  	memset(vmx_vmread_bitmap, 0xff, PAGE_SIZE);
>  	memset(vmx_vmwrite_bitmap, 0xff, PAGE_SIZE);
> -	/* shadowed read/write fields */
> -	for (i = 0; i < max_shadow_read_write_fields; i++) {
> -		clear_bit(shadow_read_write_fields[i], vmx_vmwrite_bitmap);
> -		clear_bit(shadow_read_write_fields[i], vmx_vmread_bitmap);
> -	}
> -	/* shadowed read only fields */
> -	for (i = 0; i < max_shadow_read_only_fields; i++)
> -		clear_bit(shadow_read_only_fields[i], vmx_vmread_bitmap);
>
>  	/*
>  	 * Allow direct access to the PC debug port (it is often used for I/O
>

