Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab3GZAsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:48:17 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:56662 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab3GZAsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:48:08 -0400
Message-ID: <51F1C745.60800@acm.org>
Date: Thu, 25 Jul 2013 19:48:05 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Zheng, Lv" <lv.zheng@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH 03/13] ACPI/IPMI: Fix race caused by the unprotected ACPI
 IPMI transfers
References: <cover.1370652213.git.lv.zheng@intel.com> <1520893.BbRK6T3F73@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E88024357A9@SHSMSX101.ccr.corp.intel.com> <76401540.gtU1MiBxPY@vostro.rjw.lan> <51F16A96.6040706@acm.org> <1AE640813FDE7649BE1B193DEA596E8802435A78@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802435A78@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 07:16 PM, Zheng, Lv wrote:
>>
>> If I understand this correctly, the problem would be if:
>>
>> rem_time = wait_for_completion_timeout(&tx_msg->tx_complete,
>>                                           IPMI_TIMEOUT);
>>
>> returns on a timeout, then checks msg_done and races with something setting
>> msg_done.  If that is the case, you would need the smp_rmb() before checking
>> msg_done.
>>
>> However, the timeout above is unnecessary.  You are using
>> ipmi_request_settime(), so you can set the timeout when the IPMI command
>> fails and returns a failure message.  The driver guarantees a return message
>> for each request.  Just remove the timeout from the completion, set the
>> timeout and retries in the ipmi request, and the completion should handle the
>> barrier issues.
> It's just difficult for me to determine retry count and timeout value, maybe retry=0, timeout=IPMI_TIMEOUT is OK.
> The code of the timeout completion is already there, I think the quick fix code should not introduce this logic.
> I'll add a new patch to apply your comment.

Since it is a local BMC, I doubt a retry is required.  That is probably 
fine.  Or you could set retry=1 and timeout=IPMI_TIMEOUT/2 if you wanted 
to be more sure, but I doubt it would make a difference.  The only time 
you really need to worry about retries is if you are resetting the BMC 
or it is being overloaded.

>
>> Plus, from a quick glance at the code, it doesn't look like it will properly handle a
>> situation where the timeout occurs and is handled then the response comes in
>> later.
> PATCH 07 fixed this issue.
> Here we just need the smp_rmb() or holding tx_msg_lock() around the acpi_format_ipmi_response().

If you apply the fix like I suggest, then the race goes away.  If 
there's no timeout and it just waits for the completion, things get a 
lot simpler.

>
> Thanks for commenting.

No problem, thanks for working on this.

-corey
