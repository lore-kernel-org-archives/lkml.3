Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbaFZMCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:02:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59551 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbaFZMCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:02:47 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-de-53ac0be49c8b
Message-id: <53AC0BCC.1010608@samsung.com>
Date: Thu, 26 Jun 2014 14:02:20 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        devicetree@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Daniel Drake <drake@endlessm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 0/3] Deterministic UART numbering on Samsung SoCs
References: <1403781875-5425-1-git-send-email-t.figa@samsung.com>
 <20140626113939.GP32514@n2100.arm.linux.org.uk>
In-reply-to: <20140626113939.GP32514@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Zd0n3GuCDVZt17WYf+Qcq8Wj+Y+Z
	LZoXr2ez+Px7F6tF74KrbBabHl9jtbi8aw6bxYzz+5gszizuZbe4fZnXYu2Ru+wWS69fZLJo
	3XuE3WLVrj+MDnwea+atYfRoae5h81j0Pctj56y77B6bVnWyeeyfu4bdY/OSeo++LasYPc4s
	OMLu8XmTXABXFJdNSmpOZllqkb5dAlfG1p4tbAUPBSvWHfBtYNzK18XIySEhYCLxZMk0Nghb
	TOLCvfVANheHkMBSRomJn5czQzifGSV+T7jGBFLFK6AlceDGYrAOFgFViUer3jKD2GwCahKf
	Gx6BxfmBatY0XWfpYuTgEBWIkHh8QQiiVVDix+R7LCC2iICpxLVHz8BamQXuMkss2hEPYgsL
	uEo8eX6UEcQWEiiWOHn+LCPIGE4BG4mTzRYQ5ToS+1shbmYWkJfYvOYt8wRGwVlINsxCUjYL
	SdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGx9mUH4+JjVocYBTgYlXh4JeauDhZi
	TSwrrsw9xCjBwawkwivyGyjEm5JYWZValB9fVJqTWnyIkYmDU6qBcWPw0gNrbh79/HmjQFPG
	63dRfr+FBXZ3ShzJL8nYWXj9VfX5Y3dyde9HzLzOYSVuVTrtdYWugbV+55pposrth/q3VdhP
	Pn3npewm2QkN2xl/+CsbLWVYOeW2c4Oa40Y7y3dfnbPe5tyK73D9uP5GyOeMi1e0Qz2Oss/y
	LHk679pdoeBDJlcaXiixFGckGmoxFxUnAgBlE8y5kwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.06.2014 13:39, Russell King - ARM Linux wrote:
> On Thu, Jun 26, 2014 at 01:24:32PM +0200, Tomasz Figa wrote:
>> Current Samsung UART driver relies on probe order of particular
>> samsung-uart instances, which makes it impossible to get proper
>> initialization of ports when not all ports are available on board,
>> not even saying of deterministic device naming.
>>
>> This series intends to fix this situation by adding support to parse
>> aliases from device tree and use them to assign instance IDs to
>> particular port instances.
> 
> How about instead exporting the path/id information so that userspace
> can create /dev/serial/by-{path,id}/... for internal devices instead?
> 
> The problem you're raising is very much the same problem you have when
> there are multiple USB serial devices connected to the machine - you
> just get a bunch of /dev/ttyUSB* devices which are unordered (they can
> change on each boot, or change order if you disconnect and reconnect
> them.)
> 
> /dev/serial/by-{path,id}/ allows for a much more stable path.
> 

The problem being solved has slightly different constraints than the one
with USB serials you mentioned:

- basically Samsung UART already has its own namespace (ttySAC) and the
order inside it is well-defined - instance ID shall be the hardware
instance number as specified by documentation. The ports vary in certain
aspects and the ID is important knowledge of the driver. The problem
here was broken implementation of assigning IDs based on probe order,
which worked only because on all Exynos platforms all ports have been
always registered (which we want to change now and keep unused ones
"disabled" in DT),

- we already have a lot of userspace depending on the aforementioned
ttySAC namespace and proper ordering of instances there. While I believe
the proper solution as of today would be to go back to standard ttyS
namespace and make userspace use a smarter way of identifying the
instances (e.g. by path or id, as you suggested), I don't think this
will make anyone's life easier with current assumptions,

- correct me if I'm wrong, but I don't think the
/dev/serial/by-{path,id} would be handled in kernel's console= parameter.

Best regards,
Tomasz
