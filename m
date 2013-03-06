Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab3CFLTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:19:23 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:43718 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142Ab3CFLTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:19:18 -0500
Message-ID: <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: Matt Fleming <matt@console-pimps.org>
To: joeyli <jlee@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Schroeder <mls@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
Date: Wed, 06 Mar 2013 11:19:10 +0000
In-Reply-To: <1362555258.23932.573.camel@linux-s257.site>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 15:34 +0800, joeyli wrote:
> Hi Matt, 
> 
> 於 六，2013-03-02 於 07:41 +0800，joeyli 提到：
> > 於 五，2013-03-01 於 16:31 +0000，Matt Fleming 提到：
> > > On Fri, 2013-03-01 at 15:17 +0000, Matt Fleming wrote:
> > > > On Fri, 2013-03-01 at 11:20 +0800, Lee, Chun-Yi wrote:
> > > > > From: Michael Schroeder <mls@suse.com>
> > > > > 
> > > > > On HP z220 system (firmware version 1.54), some EFI variables are incorrectly
> > > > > named :
> > > > > 
> > > > > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> > > > > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > > > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > > > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > > > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > > > 
> > > > > That causes by the following statement in efivar_create_sysfs_entry function:
> > > > > 
> > > > >  *(short_name + strlen(short_name)) = '-';
> > > > > efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
> > > > > 
> > > > > The trailing \0 is overwritten with '-', but the next char doesn't seem to be a \0
> > > > > as well for HP. So, the second strlen return the point of next '\0', causes there
> > > > > have garbage string attached before GUID.
> > > > > 
> > > > > Tested on On HP z220.
> > > > 
> > > > What's more likely happening here is that GetNextVariable() is broken on
> > > > this HP firmware and variable_name_size is too big for the given
> > > > variable in variable_name. We've seen other reports of similar bugs,
> > > > 
> > > > 	https://bugzilla.kernel.org/show_bug.cgi?id=47631
> > > > 
> > > > 
> > > > Could someone try this patch against Linus' tree?
> > > 
> > > Urgh, and here's a version that isn't utterly, utterly broken...
> > 
> > Thanks for Matt's patch, we will try it!
> > 
> > Joey Lee
> 
> Frederic confirmed your patch works to him for fix issue on HP machine.
> 
> Tested-by: Frederic Crozat <fcrozat@suse.com>
> 
> But, I suggest we just use the length with NULL in variable_name but not
> VariableNameSize that was returned by GetNextVariableName.
> 
> My thinking is following...
> 
> > 
> > > 
> > > ---
> > > 
> > > >From 4b2ef72bca72039717efe4570ec858a86d565b34 Mon Sep 17 00:00:00 2001
> > > From: Matt Fleming <matt.fleming@intel.com>
> > > Date: Fri, 1 Mar 2013 14:49:12 +0000
> > > Subject: [PATCH] efivars: Sanitise string length returned by
> > >  GetNextVariableName()
> > > 
> > > Some buggy firmware implementations return a string length from
> > > GetNextVariableName() that is actually larger than the string in
> > > 'variable_name', as Michael Schroeder writes,
> > > 
> > >   > On HP z220 system (firmware version 1.54), some EFI variables are
> > >   > incorrectly named :
> > >   >
> > >   > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> > >   > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > >   > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > >   > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> > >   > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c
> > > 
> > > Since 'variable_name' is a string, we can validate its size by
> > > searching for the terminating NULL character.
> > > 
> > > Reported-by: Frederic Crozat <fcrozat@suse.com>
> > > Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> > > Cc: Josh Boyer <jwboyer@redhat.com>
> > > Cc: Michael Schroeder <mls@suse.com>
> > > Cc: Lee, Chun-Yi <jlee@suse.com>
> > > Cc: Lingzhu Xiang <lxiang@redhat.com>
> > > Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> > > ---
> > >  drivers/firmware/efivars.c | 30 ++++++++++++++++++++++++++++++
> > >  1 file changed, 30 insertions(+)
> > > 
> > > diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> > > index 7320bf8..ab477b8 100644
> > > --- a/drivers/firmware/efivars.c
> > > +++ b/drivers/firmware/efivars.c
> > > @@ -1895,6 +1895,33 @@ void unregister_efivars(struct efivars *efivars)
> > >  }
> > >  EXPORT_SYMBOL_GPL(unregister_efivars);
> > >  
> > > +/*
> > > + * Sanity check size of a variable name.
> > > + */
> > > +static unsigned long sanity_check_size(efi_char16_t *variable_name,
> > > +				       unsigned long variable_name_size)
> > > +{
> > > +	unsigned long len;
> > > +	efi_char16_t c;
> > > +
> > > +	/*
> > > +	 * The variable name is, by definition, a NULL-terminated
> > > +	 * string, so make absolutely sure that variable_name_size is
> > > +	 * the value we expect it to be. If not, return the real size.
> > > +	 */
> > > +	for (len = 2; len <= variable_name_size; len += sizeof(c)) {
> > > +		c = variable_name[(len / sizeof(c)) - 1];
> > > +		if (!c)
> > > +			break;
> > > +	}
> > > +
> 
> We just direct return the len here but don't need compare with
> variable_name_size.
> 
> 	return len;
> 
> > > +
> > > +	if (len != variable_name_size)
> > > +		printk(KERN_WARNING "efivars: bogus variable_name_size: %lu %lu\n", len, variable_name_size);
> > > +
> > > +	return min(len, variable_name_size);
> > > +}
> > > +
> 
> In UEFI 2.3.1 spec:
> 
> VariableNameSize		The size of the VariableName buffer
> 
> Note that if EFI_BUFFER_TOO_SMALL is returned, the VariableName buffer
> was too small for the next variable. When such an error occurs, the
> VariableNameSize is updated to reflect the size of buffer needed. In all
> cases when calling GetNextVariableName() the VariableNameSize must not
> exceed the actual buffer size that was allocated for VariableName.
> 
> 
> Per spec, VariableNameSize will updated to 'the size of buffer needed'
> when EFI_BUFFER_TOO_SMALL, but spec doesn't mention VariableNameSize
> will also updated when EFI_SUCCESS. That means 'VariableNameSize = 1024'
> when EFI_SUCCESS is not a bogus value.
> 
> > >  int register_efivars(struct efivars *efivars,
> > >  		     const struct efivar_operations *ops,
> > >  		     struct kobject *parent_kobj)
> > > @@ -1941,8 +1968,11 @@ int register_efivars(struct efivars *efivars,
> > >  		status = ops->get_next_variable(&variable_name_size,
> > >  						variable_name,
> > >  						&vendor_guid);
> > > +
> > >  		switch (status) {
> > >  		case EFI_SUCCESS:
> > > +			variable_name_size = sanity_check_size(variable_name,
> > > +							       variable_name_size);
> > >  			efivar_create_sysfs_entry(efivars,
> > >  						  variable_name_size,
> > >  						  variable_name,
> > 
> 
> Due to variable_name_size could be 1024, so I suggest direct feed the
> length of variable_name to efivar_create_sysfs_entry since we are need
> to count the length.
> 
> This is a simply diff for my think:
> 
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 7320bf8..99a4f9f 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -1895,6 +1895,21 @@ void unregister_efivars(struct efivars *efivars)
>  }
>  EXPORT_SYMBOL_GPL(unregister_efivars);
>  
> +static unsigned long variable_name_length(efi_char16_t *variable_name)
> +{
> +	unsigned long len;
> +	efi_char16_t c;
> +
> +	len = 2;
> +	do {
> +		c = variable_name[len / sizeof(c) - 1];
> +		if (c)
> +			len += sizeof(c);
> +	} while (c);
> +
> +	return len;
> +}
> +
>  int register_efivars(struct efivars *efivars,
>  		     const struct efivar_operations *ops,
>  		     struct kobject *parent_kobj)
> @@ -1944,7 +1959,7 @@ int register_efivars(struct efivars *efivars,
>  		switch (status) {
>  		case EFI_SUCCESS:
>  			efivar_create_sysfs_entry(efivars,
> -						  variable_name_size,
> +						  variable_name_length(variable_name),
>  						  variable_name,
>  						  &vendor_guid);
>  			break;
> 

Hmm.. the reason I didn't implement the patch this way is because I do
think it's important to make sure we don't go out of bounds looking for
the terminating NULL, i.e. you need a 'len < variable_name_size' check
somewhere.

Care to update and resend your patch, ensuring we don't inspect more
than variable_name_size characters?

Also, which machine did you see this behaviour on?

-- 
Matt Fleming, Intel Open Source Technology Center

