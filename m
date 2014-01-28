Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaA1M2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:28:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaA1M2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:28:44 -0500
Message-ID: <52E7A26D.4000205@redhat.com>
Date: Tue, 28 Jan 2014 20:28:29 +0800
From: Fu Wei <wefu@redhat.com>
Reply-To: Fu Wei <wefu@redhat.com>
Organization: Red Hat Software (Beijing) Co.,Ltd.Shanghai Branch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Harry Wei <harryxiyou@gmail.com>
CC: Will Deacon <will.deacon@arm.com>,
        Greg-Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Doc ML <linux-doc@vger.kernel.org>,
        Fu Wei <tekkamanninja@gmail.com>, Mark Salter <msalter@redhat.com>,
        Roy Franz <roy.franz@linaro.org>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH]Documentation:Update Documentation/zh_CN/arm64/booting.txt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a update of Chinese documentation: Documentation/zh_CN/arm64/booting.txt

It is based on the modifications of Documentation/arm64/booting.txt in submission:
"4d5e0b15", "4370eec0", "4fcd6e14".

Update maintainer's Email address.

Signed-off-by: Fu Wei <wefu@redhat.com>

---
diff --git a/Documentation/zh_CN/arm64/booting.txt b/Documentation/zh_CN/arm64/booting.txt
index 28fa325..6f6d956 100644
--- a/Documentation/zh_CN/arm64/booting.txt
+++ b/Documentation/zh_CN/arm64/booting.txt
@@ -7,7 +7,7 @@ help.  Contact the Chinese maintainer if this translation is outdated
 or if there is a problem with the translation.
 
 Maintainer: Will Deacon <will.deacon@arm.com>
-Chinese maintainer: Fu Wei <tekkamanninja@gmail.com>
+Chinese maintainer: Fu Wei <wefu@redhat.com>
 ---------------------------------------------------------------------
 Documentation/arm64/booting.txt 的中文翻译
 
@@ -16,9 +16,9 @@ Documentation/arm64/booting.txt 的中文翻译
 译存在问题，请联系中文版维护者。
 
 英文版维护者： Will Deacon <will.deacon@arm.com>
-中文版维护者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
-中文版翻译者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
-中文版校译者： 傅炜  Fu Wei <tekkamanninja@gmail.com>
+中文版维护者： 傅炜  Fu Wei <wefu@redhat.com>
+中文版翻译者： 傅炜  Fu Wei <wefu@redhat.com>
+中文版校译者： 傅炜  Fu Wei <wefu@redhat.com>
 
 以下为正文
 ---------------------------------------------------------------------
@@ -64,8 +64,8 @@ RAM，或可能使用对这个设备已知的 RAM 信息，还可能使用任何
 
 必要性: 强制
 
-设备树数据块（dtb）大小必须不大于 2 MB，且位于从内核映像起始算起第一个
-512MB 内的 2MB 边界上。这使得内核可以通过初始页表中的单个节描述符来
+设备树数据块（dtb）必须 8 字节对齐，并位于从内核映像起始算起第一个 512MB
+内，且不得跨越 2MB 对齐边界。这使得内核可以通过初始页表中的单个节描述符来
 映射此数据块。
 
 
@@ -84,13 +84,23 @@ AArch64 内核当前没有提供自解压代码，因此如果使用了压缩内
 
 必要性: 强制
 
-已解压的内核映像包含一个 32 字节的头，内容如下：
+已解压的内核映像包含一个 64 字节的头，内容如下：
 
-  u32 magic	= 0x14000008;	/* 跳转到 stext, 小端 */
-  u32 res0	= 0;		/* 保留 */
+  u32 code0;			/* 可执行代码 */
+  u32 code1;			/* 可执行代码 */
   u64 text_offset;		/* 映像装载偏移 */
+  u64 res0	= 0;		/* 保留 */
   u64 res1	= 0;		/* 保留 */
   u64 res2	= 0;		/* 保留 */
+  u64 res3	= 0;		/* 保留 */
+  u64 res4	= 0;		/* 保留 */
+  u32 magic	= 0x644d5241;	/* 魔数, 小端, "ARM\x64" */
+  u32 res5 = 0;      		/* 保留 */
+
+
+映像头注释：
+
+- code0/code1 负责跳转到 stext.
 
 映像必须位于系统 RAM 起始处的特定偏移（当前是 0x80000）。系统 RAM
 的起始地址必须是以 2MB 对齐的。
@@ -118,9 +128,9 @@ AArch64 内核当前没有提供自解压代码，因此如果使用了压缩内
   外部高速缓存（如果存在）必须配置并禁用。
 
 - 架构计时器
-  CNTFRQ 必须设定为计时器的频率。
-  如果在 EL1 模式下进入内核，则 CNTHCTL_EL2 中的 EL1PCTEN (bit 0)
-  必须置位。
+  CNTFRQ 必须设定为计时器的频率，且 CNTVOFF 必须设定为对所有 CPU
+  都一致的值。如果在 EL1 模式下进入内核，则 CNTHCTL_EL2 中的
+  EL1PCTEN (bit 0) 必须置位。
 
 - 一致性
   通过内核启动的所有 CPU 在内核入口地址上必须处于相同的一致性域中。
@@ -131,23 +141,40 @@ AArch64 内核当前没有提供自解压代码，因此如果使用了压缩内
   在进入内核映像的异常级中，所有构架中可写的系统寄存器必须通过软件
   在一个更高的异常级别下初始化，以防止在 未知 状态下运行。
 
+以上对于 CPU 模式、高速缓存、MMU、架构计时器、一致性、系统寄存器的
+必要条件描述适用于所有 CPU。所有 CPU 必须在同一异常级别跳入内核。
+
 引导装载程序必须在每个 CPU 处于以下状态时跳入内核入口：
 
 - 主 CPU 必须直接跳入内核映像的第一条指令。通过此 CPU 传递的设备树
-  数据块必须在每个 CPU 节点中包含以下内容：
-
-    1、‘enable-method’属性。目前，此字段支持的值仅为字符串“spin-table”。
-
-    2、‘cpu-release-addr’标识一个 64-bit、初始化为零的内存位置。
+  数据块必须在每个 CPU 节点中包含一个 ‘enable-method’ 属性，所
+  支持的 enable-method 请见下文。
 
   引导装载程序必须生成这些设备树属性，并在跳入内核入口之前将其插入
   数据块。
 
-- 任何辅助 CPU 必须在内存保留区（通过设备树中的 /memreserve/ 域传递
+- enable-method 为 “spin-table” 的 CPU 必须在它们的 CPU
+  节点中包含一个 ‘cpu-release-addr’ 属性。这个属性标识了一个
+  64 位自然对齐且初始化为零的内存位置。
+
+  这些 CPU 必须在内存保留区（通过设备树中的 /memreserve/ 域传递
   给内核）中自旋于内核之外，轮询它们的 cpu-release-addr 位置（必须
   包含在保留区中）。可通过插入 wfe 指令来降低忙循环开销，而主 CPU 将
   发出 sev 指令。当对 cpu-release-addr 所指位置的读取操作返回非零值
-  时，CPU 必须直接跳入此值所指向的地址。
+  时，CPU 必须跳入此值所指向的地址。此值为一个单独的 64 位小端值，
+  因此 CPU 须在跳转前将所读取的值转换为其本身的端模式。
+
+- enable-method 为 “psci” 的 CPU 保持在内核外（比如，在
+  memory 节点中描述为内核空间的内存区外，或在通过设备树 /memreserve/
+  域中描述为内核保留区的空间中）。内核将会发起在 ARM 文档（编号
+  ARM DEN 0022A：用于 ARM 上的电源状态协调接口系统软件）中描述的
+  CPU_ON 调用来将 CPU 带入内核。
+
+  *译者注:到文档翻译时，此文档已更新为 ARM DEN 0022B。
+
+  设备树必须包含一个 ‘psci’ 节点，请参考以下文档：
+  Documentation/devicetree/bindings/arm/psci.txt
+
 
 - 辅助 CPU 通用寄存器设置
   x0 = 0 (保留，将来可能使用)
