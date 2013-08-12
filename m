Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3HLODX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043Ab3HLODU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:03:20 -0400
Message-ID: <1376316160.32237.17.camel@t520.redhat.com>
Subject: Re: [PATCH V3 RFC 00/16]  EFI stub for ARM
From: Mark Salter <msalter@redhat.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk, leif.lindholm@linaro.org, dave.martin@arm.com
Date: Mon, 12 Aug 2013 10:02:40 -0400
In-Reply-To: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
> * Change FDT memory allocation to retry with a larger allocation if
>   first educated guess is inadequate.

With this change, it looks like you no longer free the original cmdline
and fdt memory. The current flow looks like:

  retry:
     allocate_memory_for_expanded_fdt
     get_memory_map
     if (update_fdt() fails) {
        free new_fdt and memory_map
        goto retry
     }

So, this keeps the original fdt around and uses it as a starting point
for newly allocated expanded fdt. You don't know if the new fdt is big
enough until update_fdt() succeeds. But at that point, you already wrote
the efi-runtime-mmap property with the memory_map still having the
original cmdline and fdt in it.

I think you should be able to have an expand_fdt() function which bumps
the fdt size and uses the current fdt as the starting point instead of
the original fdt. That way you can free the original fdt on the first
iteration and free the original cmdline as soon as it is successfully
written. Then the last thing you do if get the memory_map and write it.

--Mark



        
     

