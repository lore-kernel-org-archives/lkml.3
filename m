Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbbASUAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:00:08 -0500
Received: from smtp-out-179.synserver.de ([212.40.185.179]:1113 "EHLO
	smtp-out-179.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbbASUAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:00:07 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 20306
Message-ID: <54BD62B5.7050205@metafoo.de>
Date: Mon, 19 Jan 2015 21:01:57 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>, Julia Lawall <julia.lawall@lip6.fr>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH] i2c: drop ancient protection against sysfs refcounting
 issues
References: <1421693756-12917-1-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1421693756-12917-1-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 07:55 PM, Wolfram Sang wrote:
[...]
>
> Let's get rid of this code before really nobody knows/understands
> anymore what this was for and if it has a subtle use.

Getting rid of this is the right thing, cause it's just not how it should be 
done, but unfortunately it is not as simple as this. The problem is that the 
adapter is typically embedded in the parent device's state struct. This state 
struct is typically freed directly after calling i2c_del_adapter(). If there is 
still something holding a reference to the adapter this will result in a use 
after free. To do this properly i2c_add_adapter() needs to be changed to 
i2c_alloc_adapter() that returns a pointer to a newly allocated adapter. 
i2c_free_adapter() will then only drop a reference to the adapter, but not free 
any memory. Once the last reference has been removed the memory can then be 
freed in the release callback.

The other issue is as long as something has a reference to the adapter they can 
run operations on the adapter. So freeing the adapter also has to make sure 
that any further operations that are performed on the adapter do no longer call 
into the device specific ops, but rather returns -ENODEV, or similar.

- Lars
