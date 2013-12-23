Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3LWHqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 02:46:52 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58307 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3LWHqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 02:46:51 -0500
X-AuditID: 9c93017d-b7c2eae000004ec2-f2-52b7ea691196
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt \(Red Hat\)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip 3/3] perf-probe: Use the actual address as a hint for uprobes
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal>
	<20131220100302.7169.96318.stgit@kbuild-fedora.novalocal>
	<20131220180351.GC28878@ghostprotocols.net>
	<52B75F9E.7000802@hitachi.com>
Date: Mon, 23 Dec 2013 16:46:49 +0900
In-Reply-To: <52B75F9E.7000802@hitachi.com> (Masami Hiramatsu's message of
	"Mon, 23 Dec 2013 06:54:38 +0900")
Message-ID: <87wqiwc8ly.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013 06:54:38 +0900, Masami Hiramatsu wrote:
> (2013/12/21 3:03), Arnaldo Carvalho de Melo wrote:
>> Em Fri, Dec 20, 2013 at 10:03:02AM +0000, Masami Hiramatsu escreveu:
> BTW, I'm not sure why debuginfo and nm shows symbol address + 0x400000,
> and why the perf's map/symbol can remove this offset. Could you tell me
> how it works?
> If I can get the offset (0x400000) from binary, I don't need this kind
> of ugly hacks...

AFAIK the actual symbol address is what nm (and debuginfo) shows.  But
perf adjusts symbol address to have a relative address from the start of
mapping (i.e. file offset) like below:

	sym.st_value -= shdr.sh_addr - shdr.sh_offset;

This way, we can handle mmap and symbol address almost uniformly
(i.e. ip = map->start + symbol->address).  But this requires the mmap
event during perf record.  For perf probe, we might need to synthesize
mapping info from the section/segment header since it doesn't have the
mmap event.  Currently, the dso__new_map() just creates a map starts
from 0.

Thanks,
Namhyung
