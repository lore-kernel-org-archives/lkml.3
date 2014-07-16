Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaGPXIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:08:43 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:42895 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbaGPXIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:08:36 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Cc: Christoph Lameter <cl@linux.com>
Subject: [PATCH v2 1/1] doc: Add remote CPU access details and others to this_cpu_ops.txt
Date: Wed, 16 Jul 2014 19:09:01 -0400
Message-Id: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more details from a recent kernel newbies mailing list discussion here:
http://www.spinics.net/lists/newbies/msg52747.html

Also list the operations available and add details about safe accesses.

v2: 
* updated with comments from Christoph Lameter

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
CC: Christoph Lameter <cl@linux.com>
---
 Documentation/this_cpu_ops.txt | 129 ++++++++++++++++++++++++++++++++++-------
 scripts/bin2c                  | Bin 0 -> 8706 bytes
 2 files changed, 108 insertions(+), 21 deletions(-)
 create mode 100755 scripts/bin2c

diff --git a/Documentation/this_cpu_ops.txt b/Documentation/this_cpu_ops.txt
index 1a4ce7e..b1faa9d 100644
--- a/Documentation/this_cpu_ops.txt
+++ b/Documentation/this_cpu_ops.txt
@@ -13,22 +13,51 @@ operating on the per cpu variable.
 
 This means there are no atomicity issues between the calculation of
 the offset and the operation on the data. Therefore it is not
-necessary to disable preempt or interrupts to ensure that the
+necessary to disable preemption or interrupts to ensure that the
 processor is not changed between the calculation of the address and
 the operation on the data.
 
 Read-modify-write operations are of particular interest. Frequently
 processors have special lower latency instructions that can operate
-without the typical synchronization overhead but still provide some
-sort of relaxed atomicity guarantee. The x86 for example can execute
-RMV (Read Modify Write) instructions like inc/dec/cmpxchg without the
+without the typical synchronization overhead, but still provide some
+sort of relaxed atomicity guarantees. The x86, for example, can execute
+RMW (Read Modify Write) instructions like inc/dec/cmpxchg without the
 lock prefix and the associated latency penalty.
 
 Access to the variable without the lock prefix is not synchronized but
 synchronization is not necessary since we are dealing with per cpu
 data specific to the currently executing processor. Only the current
 processor should be accessing that variable and therefore there are no
-concurrency issues with other processors in the system.
+concurrency issues with other processors in the system. Please see the 
+section "Remote access to per-CPU data" if you need remote access.
+
+The main use of the this_cpu operations has been to optimize counter
+operations. 
+
+The following this_cpu() operations with implied preemption protection
+are defined. These operations can be used without worrying about
+preemption and interrupts.
+	
+	this_cpu_add()
+	this_cpu_read(pcp)
+	this_cpu_write(pcp, val)	
+	this_cpu_add(pcp, val)		
+	this_cpu_and(pcp, val)		
+	this_cpu_or(pcp, val)		
+	this_cpu_add_return(pcp, val)	
+	this_cpu_xchg(pcp, nval)	
+	this_cpu_cmpxchg(pcp, oval, nval) 
+	this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2) 
+	this_cpu_sub(pcp, val)		
+	this_cpu_inc(pcp)		
+	this_cpu_dec(pcp)		
+	this_cpu_sub_return(pcp, val)	
+	this_cpu_inc_return(pcp)	
+	this_cpu_dec_return(pcp)	
+
+
+Inner working of this_cpu operations
+------------------------------------
 
 On x86 the fs: or the gs: segment registers contain the base of the
 per cpu area. It is then possible to simply use the segment override
@@ -53,12 +82,11 @@ this_cpu_ops such sequence also required preempt disable/enable to
 prevent the kernel from moving the thread to a different processor
 while the calculation is performed.
 
-The main use of the this_cpu operations has been to optimize counter
-operations.
+Consider the following this_cpu operation
 
 	this_cpu_inc(x)
 
-results in the following single instruction (no lock prefix!)
+The above results in the following single instruction (no lock prefix!)
 
 	inc gs:[x]
 
@@ -100,11 +128,10 @@ Takes the offset of a per cpu variable (&x !) and returns the address
 of the per cpu variable that belongs to the currently executing
 processor.  this_cpu_ptr avoids multiple steps that the common
 get_cpu/put_cpu sequence requires. No processor number is
-available. Instead the offset of the local per cpu area is simply
+available. Instead, the offset of the local per cpu area is simply
 added to the percpu offset.
 
 
-
 Per cpu variables and offsets
 -----------------------------
 
@@ -118,15 +145,16 @@ Therefore the use of x or &x outside of the context of per cpu
 operations is invalid and will generally be treated like a NULL
 pointer dereference.
 
-In the context of per cpu operations
+	DEFINE_PER_CPU(int, x);
 
-	x is a per cpu variable. Most this_cpu operations take a cpu
-	variable.
+In the context of per cpu operations the above implies that x is a per
+cpu variable. Most this_cpu operations take a cpu variable.
 
-	&x is the *offset* a per cpu variable. this_cpu_ptr() takes
-	the offset of a per cpu variable which makes this look a bit
-	strange.
+	int __percpu *p = &x;
 
+&x and hence p is the *offset* of a per cpu variable. this_cpu_ptr() 
+takes the offset of a per cpu variable which makes this look a bit
+strange.
 
 
 Operations on a field of a per cpu structure
@@ -172,16 +200,40 @@ if we do not make use of this_cpu ops later to manipulate fields:
 Variants of this_cpu ops
 -------------------------
 
-this_cpu ops are interrupt safe. Some architecture do not support
+this_cpu ops are interrupt safe. Some architectures do not support
 these per cpu local operations. In that case the operation must be
 replaced by code that disables interrupts, then does the operations
 that are guaranteed to be atomic and then reenable interrupts. Doing
 so is expensive. If there are other reasons why the scheduler cannot
 change the processor we are executing on then there is no reason to
-disable interrupts. For that purpose the __this_cpu operations are
-provided. For example.
+disable interrupts. For that purpose the following __this_cpu operations
+are provided. 
+
+These operations have no guarantee against concurrent interrupts or
+preemption. If a per cpu variable is not used in an interrupt context
+and the scheduler cannot preempt then they are safe.
+
+Note that interrupts may still occur while an operation is
+in progress and if the interrupt too modifies the variable, then RMW
+actions may not be atomic.
+
+	__this_cpu_add()
+	__this_cpu_read(pcp)
+	__this_cpu_write(pcp, val)	
+	__this_cpu_add(pcp, val)		
+	__this_cpu_and(pcp, val)		
+	__this_cpu_or(pcp, val)		
+	__this_cpu_add_return(pcp, val)	
+	__this_cpu_xchg(pcp, nval)	
+	__this_cpu_cmpxchg(pcp, oval, nval) 
+	__this_cpu_cmpxchg_double(pcp1, pcp2, oval1, oval2, nval1, nval2) 
+	__this_cpu_sub(pcp, val)		
+	__this_cpu_inc(pcp)		
+	__this_cpu_dec(pcp)		
+	__this_cpu_sub_return(pcp, val)	
+	__this_cpu_inc_return(pcp)	
+	__this_cpu_dec_return(pcp)	
 
-	__this_cpu_inc(x);
 
 Will increment x and will not fallback to code that disables
 interrupts on platforms that cannot accomplish atomicity through
@@ -189,7 +241,6 @@ address relocation and a Read-Modify-Write operation in the same
 instruction.
 
 
-
 &this_cpu_ptr(pp)->n vs this_cpu_ptr(&pp->n)
 --------------------------------------------
 
@@ -202,4 +253,40 @@ with (). The second form also is consistent with the way
 this_cpu_read() and friends are used.
 
 
+Remote access to per-CPU data
+------------------------------
+
+Per cpu data structures are for the use of one cpu exclusively. If you
+use the variables as intended, this_cpu_ops() are guaranteed to be
+"atomic" as no other CPU has access to these data structures. But there
+are special cases where you might need to access per cpu data structures
+remotely. One such case is to perform maintenance tasks of idle CPUs
+without having to wake them up using IPIs for power saving purposes.
+It is usually safe to do a remote read access and that is frequently
+done to summarize counters. Remote write access is the one which is
+problematic. This is not recommended unless absolutely necessary.
+
+To access per-cpu data structure remotely, you need to convert the 
+per-cpu offset to a pointer using this_cpu_ptr().
+
+	DEFINE_PER_CPU(struct data, datap);
+	struct data *p = per_cpu(&datap, cpu);
+
+p can now be passed to another CPU to be updated remotely.
+
+This makes it explicit that we are getting ready to access a foreing
+percpu area.
+
+You can also do the following to convert the datap offset to an address
+
+	struct data *p = this_cpu_ptr(&datap);
+
+but, passing of pointers calculated via this_cpu_ptr to other cpus is
+unusual and should be avoided.
+
+Such remote accesses to per CPU data are not guaranteed to be atomic
+anymore. You will have to use atomic_t and rely on the standard atomic
+operations for these remote accesses to be atomic.
+
 Christoph Lameter, April 3rd, 2013
+Pranith Kumar, July 16th, 2014
diff --git a/scripts/bin2c b/scripts/bin2c
new file mode 100755
index 0000000000000000000000000000000000000000..58f44ba9ae94ca23445e244fb83132e779ffe4ad
GIT binary patch
literal 8706
zcmeHMZ){W76~DIgkI*`XF&1Dg9t~4kEhb4J4Mnui`2)`=2^lyo9fTLhb`r0N9of%q
z!lW)*+Nv(JtF%?B_F-cmrtx9Yx@nr|G=XWR_RECmv`X!|P7xYY(mxVYS%jv6_dEC9
zV?Vz*64JD9T+8>I^SkGq`{&(z?z``Px3}+r+vO6R+~P4o((P(ZLRK!sxeZcOSf^Mg
zG;zP!CTf6G<FCmQq87*WrgF`+PU(3-tMKo1TR^8<lMK_ZTCiZsEhI|ym6E1di+-jm
zU@C-PmXjT|)#sHW=!j&PYN{QBin1MvWY?_hnw1^XE2?2kxqs9*`iGUjuv>#fvPMMo
z$h<^Jm(t)hGe-QIwNeDtB*S#K1q-HZ_f6PQJMT34l;ROp-&*5xUG<Nt62-2`#AwIv
zU6Zkv$wV?c(=yZ9(bBOykVysFWxvTk=^h*yk~Q%-HbSB{Z^EDE0F{65(r=ER*?aQX
zlYcvZ^?jpuZu4N@A=W1!R=@mW4m>52$A==^1&KK`s%N7Ug#3*)@W+7r@pq;N095j`
zehvIS;2XpiG3XlsCj`$2f$@sc@N@{nm`*2>=9m$kcv?(n&5X#Hu|!fBp~J>_+>Anj
zl#PrTNt?!0go=#usZ>%ShB(+4>gqPy0}lsw7y0(U9;(lcALSlN=^41?bKt=;w<Oll
z$oE5wu<TZn-Qp?mlx{YRNJ?W&&xaHDht{5bo;9j|(sbpyK{kFHu9g77qS=Pq{kPh1
zp3|h?X~XU7UZ4N0PCs3}XT4wOFXYYYrEVze^M9yYAgfX;?AZa8!p<h-4cj$vBu|jS
z@?rsL=T?%b>C0E7ypd#T@^W6v^(0eMm*14Kn`CO@@>$5i@O;4)%H0^s-8%YQ(|p1G
z)-SPQ%_{x$fG>19+*EhLgnW_wx8;{Ez@qIVYR83~4gNXchV66E5&G%<Z`J$7(({1k
zZx+m5xwq#RTy6OaXIOt}7DX!y4cR|md>Po%Ll8fGvtj%5WG*ahGg;qqJ=Z9kko)k$
z57-)w*o(sB!)^KCiG{Y$L%H`(>ba}>{NJw+hC}b>N1&*`d+B-&k#{xh0!ts>E);IC
z|MO4cfeh&_G#~W&n_fM4?OFHm!g;Ej9>k5|i&RutRQ)+m66;^O>4CnUdt1Ns$>X}~
zik^E%fA4k{_P?|2|5UWUs_f_X|7x8d({#fSESH``(}&-w{xKle7Yj6w`uzT5wNNm(
z6`QbO=%OD{8v2DR!^_`+$?`ME#u~Qw2oZcTm@5RI2<29SL!sRJ!EoOzJL}+JNPne;
z=+V9hueE)oU%KU?8MgHLtwKS6;dAqT?tfqIlfK+a4}26h{Z+@K(f59u{e&jo@!{Z!
z;BfF{&{!B73$Xqdn2&O<s;NoqF`7zdOn-DDlJ@V+93Muuzh11{Ax_NfY;B(r>-N>x
zTPlbWC^RyOQ*r-(|IXOHdg0pU*+;Rz8vj-_ZVvP{&~u;zcu<3&8hZNyD9u;DT9g!T
zDY;G^5w01ZYui1wb+5T<eT35<y8<5%k%CH<^@V6cIq9GKPoXeEx?bM_Z{wkc_0QJL
ziO09@d+6b&9RyRH#c+#7=v^S7%j-MiKIm<H(bMhq&sVvB;cX0heLdbfDztP>&=K?@
zP5|`3@9y<BzUt}q`d_K)^){cW*1fGS*67~O`PzQ3HtFpQdRv3u<}R<l%i9S3E;yrh
z{~rIB;Kv?!$mQL1cLeT^z}*qJI|6HuKpq=ErL&4k0U5vBF}+6>oUhU(cdwFTcz>X@
zMdozg8j;*KC97~Rwko+%mD8R=iOc_WyO1LJ4Yx+5c;=h%SaOX-g~+=txn9X~?*LEl
z=ad>PBEGCB6MCVO39l!Vc(0g|l65{IRvp8{R}`+P{xa@UGPk=`>EWeXCaxdbk?hZ+
zYCpDSDf4(<SMp_5uFU`MgwL_gidIy=YVZa~X|tkVSF}S>S!l}+c6UGOZyp-WCe7@w
zzC<#TPWg8S9tk|$($=1pXxoDpAndAuIs@%3ZF_Ax0E7r+W~a=^D5#mX=mc|kJBp{L
zMIf0n<AGpTsKtzoD``BL4UA?JIGrY9B0$naBr_obvDqa2S=3BhCC|junM5jCCKxD7
z$0s9Xpt$KtQv?#p1adPzgM17E%2Kh284-c_gfW(mOvR0f7;IUxER0Ax9htQ(nE!SZ
zYVaPJN<>k03J#G4WG$A*(M(1JqN%B=c#>X>{>Mb?kLDWB^G>%0sr3DY*PjHD@w{aD
z0Wh`rvwhgDK`MRU@Jp$bRh3xDwIR3Ln{G|wrgGRMrBdd!??KTD)(F@ChFg=$Z#eAf
zy_gcOM@z!HF&K&oY@c^)kSKmgBF<Svo^7e`Y|rcW31Ad6*q-B%JQ)J#xC2%u=lGoj
zN^73&d7WQYfk=H`D#kh1WBN4gDTc7jab!{1bKIf0Xm7u446;-B)0nb7$1R^4XtsBb
zANT)xhdswZP1(<&oD$j7-ryX+SAkKxsC|@p-#D-Ac|Wj9t+p~xG>5<4eo@7zMP)xi
zO19)vJkuXSw%cneerc-1J9uCmcI@&;4tw6`Vl=6dINn>*>h_;S0oBjdOxJ3VgqT+L
zmLwsWscsbknxA%i{vOER33nGYEyij8TZjFUs((q<Uq#MsiJu=sc`!6b)pRTF>-^o&
zsqd8k2-^mmJ@5OCYT`Tfo$?2;r6zLybi$|PzeD?vp-Xd*?Rnqh@4Ec`mggte&-3RW
zu(j9E-^p%Lr;u3Rl1eh;pQ6BSFVuU7{0N6KjSUrLJEk{)+wC=Fuc-!dJJ}7}vHWi^
zgmM4rvkaxdJG3uAm+EgNBU@to!#0dq(xt?dt`E3wS)j6?sQT+zQQ;0z`r)->w{KQ2
znj`AL-G{;!{JH-ezi53{s{f_!mbX(5=g#^qt;)Fvt?P7as|x8GY`7xs5oSfas`$QZ
zcjiG<%~#Z~!Iw$Rt}1yCc3R$F?1dhT%3?+Rb%OVUa{YRtRcUre@*eD@9KY>_9z=eQ
z%jNjJg5zyD?iCzI%kc)pMa>RL-h;)$anD}p!54RqXXW_DVw@_+za%*Rl;fKaPe$yJ
z<UKe&aJ;Y=dc@}9_wsTarv+Z$wgL}MBfM^HFy>|HzMvd;?uyoWsuKUC<ye+zepkXb
z0e9i6n6qDB1MU|0iq;wpTq$*cC49tzhZKI+fg8YGX#X+QUtTv!iLV~#*Oi~V!_QBp
z{_5woR=@I6AJ4r`16N9y!B*-oX;d1Yzev-KtLB3huU9{Jio<jx#OGQmBCAEmU35xx
zJoo#6Z=~^5^O?g;3vfRh+h|DQtLI5r`mrf0b_{r>`=(joKFl|c^K3aM{j6ShFRtPL
zXUdOr-u@c6pPkz1CEy#}jY4;f!)3zp2EgmOO4)o2oW_SP94N(QF2v^&SAvarFn~VH
zw-JZ`I^g7o@2%OSLFqfkVVlzDxFo+(!^kgjwl2{}f%{8hksAO`{dM~P)*AYB-q~0w
zevT%R?a@F~MAK%*%;E-t?g0;VA2IquN5h68V)1l*JdweX*D$Ay=wvDx&xi_;VZ>6#
z_+)A{GHJxjR61isvNO1Hn3|r9oAFqn<B@i{f~=rq(23SMpBgxGre}q9qK##zre<Mc
zlMFftm#G@Yfg{2GUZZ!Q2aUB_&U~42Oc*^+4Fvl`-O#d?$lFd~9PB&X73?z(A2@Kd
zH*AE1U46aePF{#cGg;Y2+?0m<jnaUG`@3m4!jaL*xS+$cbx|tsRyB<;OX-4CUbL1&
zMqD1Zm1F14t3%hYd3W5&Vn{P7V<M7_p%HYIE9)|{nK*h}YCrY3c+>0f9#2A5je~*X
uzv9&maOu*xWJVXj#-V47BWh}NPew8s%nQT7nDDcp!QzQhHdJ!>#eV@-GqxfC

literal 0
HcmV?d00001

-- 
1.9.1

