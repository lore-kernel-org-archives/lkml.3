Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3CAJcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:32:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab3CAJb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:31:59 -0500
Message-ID: <5130757F.4090702@redhat.com>
Date: Fri, 01 Mar 2013 17:31:43 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
CC: matt@console-pimps.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Schroeder <mls@suse.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
In-Reply-To: <1362108018-13117-1-git-send-email-jlee@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 11:20 AM, Lee, Chun-Yi wrote:
> From: Michael Schroeder <mls@suse.com>
> 
> On HP z220 system (firmware version 1.54), some EFI variables are incorrectly
> named :
> 
> ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
> /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
> /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c
> 
> That causes by the following statement in efivar_create_sysfs_entry function:
> 
>   *(short_name + strlen(short_name)) = '-';
> efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
> 
> The trailing \0 is overwritten with '-', but the next char doesn't seem to be a \0
> as well for HP. So, the second strlen return the point of next '\0', causes there
> have garbage string attached before GUID.
> 
> Tested on On HP z220.

So short_name has trailing garbage, or rather, variable_name_size
is larger than variable_name actually is, wouldn't new_efivar->var.VariableName
also gets filled with trailing garbage?

In efivar_store_raw the VariableName's trailing garbage can cause
problem for comparison. You might want to also cover that or fix
variable_name_size.


Lingzhu Xiang
