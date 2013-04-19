Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968096Ab3DSLFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 07:05:50 -0400
Received: from smtp-out-143.synserver.de ([212.40.185.143]:1141 "EHLO
	smtp-out-141.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S967914Ab3DSLFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 07:05:49 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20002
Message-ID: <517124D6.7090008@metafoo.de>
Date: Fri, 19 Apr 2013 13:04:54 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Vinod Koul <vinod.koul@intel.com>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dma:of: Use a mutex to protect the of_dma_list
References: <1366364534-3298-1-git-send-email-lars@metafoo.de> <1366364534-3298-2-git-send-email-lars@metafoo.de> <201304191213.48631.arnd@arndb.de>
In-Reply-To: <201304191213.48631.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 12:13 PM, Arnd Bergmann wrote:
> On Friday 19 April 2013, Lars-Peter Clausen wrote:
> 
>> This is rather ugly and unnecessary and non of the current users of
>> of_dma_controller_free() check it's return value anyway. Instead protect the
>> list by a mutex. The mutex will be held as long as a request operation is in
>> progress. So if of_dma_controller_free() is called while a request operation is
>> in progress it will be put to sleep and only wake up once the request operation
>> has finished.
>>
>> This means that it is no longer possible to register or unregister OF DMA
>> controllers from a context where it's not possible to sleep. But I doubt that
>> we'll ever need this.
>>
>> Also rename of_dma_get_controller back to of_dma_find_controller.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> I guess we could also fix it by turning the reference count into a proper
> kref with kref_put calling the destructor, but your solution seems to solve
> the problem just as well.

Well, It's not only about the of_dma struct, e.g. the of_dma's of_dma_data
field usually points to some driver allocated data. If we do not block in
of_dma_controller_free() this data might be freed while the controller is
still in use.
