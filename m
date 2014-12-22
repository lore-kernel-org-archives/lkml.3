Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaLVKUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:20:16 -0500
Received: from [119.145.14.64] ([119.145.14.64]:25953 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaLVKUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:20:14 -0500
Message-ID: <5497F020.5080309@huawei.com>
Date: Mon, 22 Dec 2014 18:19:12 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
CC: Zefan Li <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [BUG] A bug report between init_moudle and kallsyms_lookup_name
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.22.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List, 

We encounter a crash in kallsyms_lookup_name in our product, the kernel version is Linux 3.4.
It seems a kernel bug.

In the scene, some modules were loading in CPU A. But kallsyms_lookup_name was  
executed to find an symbol name for each modules in CPU B.

The reason seems like that, 
after the module was added to modules list in CPU A, then module_kallsyms_lookup_name 
in CPU B would found the mod. The addrs of mod->strtab and mod->symtab would be saved in register.
After the module init, the mod_symtab, strtab and num_symtab are updated to core_***, and 
the init memory will be free. It means the memory area of the old mod->strtab and mod->symtab 
is also free. But in the mod_find_symname, the addr saved in the register is still old.

		CPU A					CPU B
						module_kallsyms_lookup_name
	load_module				    -->mod_find_symname
	    -->list_add_rcu(modules)
		。。。				                          *save mod->symtab/strtab into register
	do_one_initcall
		。。。				strcmp(name, mod->strtab+mod->symtab[i].st_name)		*OK
	mod->num_symtab = mod->core_num_syms;
	mod->symtab = mod->core_symtab;
	mod->strtab = mod->core_strtab;
		。。。
	module_free（module_init）
						strcmp(name, mod->strtab+mod->symtab[i].st_name) 		*old addr, crash

The same to other two functions in kernel. Using kallsyms_on_each_symbol or module_get_kallsym would 
cause a crash, while loading an modules, too.

It seems like an old bug in kernel, and also exits in mainline. Right?
Any advice is welcome.

Thanks,
Rui

