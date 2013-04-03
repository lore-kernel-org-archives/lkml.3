Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358Ab3DCNLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:11:40 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55102 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760752Ab3DCNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:11:38 -0400
Message-ID: <515C2A86.6070606@console-pimps.org>
Date: Wed, 03 Apr 2013 14:11:34 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: matt.fleming@intel.com, ben@decadent.org.uk, jwboyer@redhat.com,
        linux-efi@vger.kernel.org, seth.forshee@canonical.com,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/2] efi: Distinguish between "remaining space" and actually
 used space
References: <515150EC.7040203@redhat.com> <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com> <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/13 16:14, Matthew Garrett wrote:
> @@ -452,8 +462,33 @@ check_var_size_locked(struct efivars *efivars, u32 attributes,
>  	if (status != EFI_SUCCESS)
>  		return status;
>  
> -	if (!storage_size || size > remaining_size || size > max_size ||
> -	    (remaining_size - size) < (storage_size / 2))
> +	list_for_each_entry(entry, &efivars->list, list) {
> +		var = &entry->var;
> +		status = get_var_data_locked(efivars, var);
> +
> +		if (status || !(var->Attributes & EFI_VARIABLE_NON_VOLATILE))
> +			continue;
> +
> +		active_size += var->DataSize;
> +		active_size += utf16_strsize(var->VariableName, 1024);
> +		/*
> +		 * There's some additional metadata associated with each
> +		 * variable. Intel's reference implementation is 60 bytes -
> +		 * bump that to 128 to account for vendor additions and
> +		 * potential alignment constraints
> +		 */
> +		active_size += 128;
> +	}

This is the kind of thing I was referring to when I said, 

  Hmm... I'm not convinced this will provide a long-term solution. Is there
  anything that mandates that the size of all variables has to correlate
  sensibly with the results from QueryVariableInfo()? Even if there is in
  theory, I doubt it'll be true everywhere in practice, and trying to
  workaround implementation bugs in our workarounds for other bugs is the
  path to madness.

  We can't continue this approach where we attempt to guess how the firmware
  implements variable storage, because as we've seen, there are various
  schemes out there. 

This looks like something that will differ between implementations, and the
fact that it's appearing in our code is a sure sign that this isn't the way to
go.

-- 
Matt Fleming, Intel Open Source Technology Center
