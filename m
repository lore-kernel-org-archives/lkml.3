Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935160Ab3DHRdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:33:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37425 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934599Ab3DHRdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:33:08 -0400
Message-ID: <5162FF18.8010802@linux.vnet.ibm.com>
Date: Mon, 08 Apr 2013 10:32:08 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] mm/page_alloc: convert zone_pcp_update() to use on_each_cpu()
 instead of stop_machine()
References: <1365194030-28939-1-git-send-email-cody@linux.vnet.ibm.com> <1365194030-28939-3-git-send-email-cody@linux.vnet.ibm.com> <5161931A.8060501@gmail.com>
In-Reply-To: <5161931A.8060501@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040817-7182-0000-0000-00000623FF58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 08:39 AM, KOSAKI Motohiro wrote:
> (4/5/13 4:33 PM), Cody P Schafer wrote:
>> No off-cpu users of the percpu pagesets exist.
>>
>> zone_pcp_update()'s goal is to adjust the ->high and ->mark members of a
>> percpu pageset based on a zone's ->managed_pages. We don't need to drain
>> the entire percpu pageset just to modify these fields. Avoid calling
>> setup_pageset() (and the draining required to call it) and instead just
>> set the fields' values.
>>
>> This does change the behavior of zone_pcp_update() as the percpu
>> pagesets will not be drained when zone_pcp_update() is called (they will
>> end up being shrunk, not completely drained, later when a 0-order page
>> is freed in free_hot_cold_page()).
>>
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> 
> NAK.
> 
> 1) zone_pcp_update() is only used from memory hotplug and it require page drain.

I'm looking at this code because I'm currently working on a patchset
which adds another interface which modifies zone sizes, so "only used
from memory hotplug" is a temporary thing (unless I discover that
zone_pcp_update() is not intended to do what I want it to do).

> 2) stop_machin is used for avoiding race. just removing it is insane.

What race? Is there a cross cpu access to ->high & ->batch that makes
using on_each_cpu() instead of stop_machine() inappropriate? It is
absolutely not just being removed.

