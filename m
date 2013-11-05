Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab3KEXtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:49:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42250 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3KEXtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:49:22 -0500
Message-ID: <527983FA.9000909@infradead.org>
Date: Tue, 05 Nov 2013 15:49:14 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: James Solner <solner@alcatel-lucent.com>, jwboyer@fedoraproject.org
CC: dhowells@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: Subject: [PATCH v1] Add Documentation/module-signing.txt file
References: <2796832.O3WlZ61LSy@cmlinux10.ih.lucent.com>
In-Reply-To: <2796832.O3WlZ61LSy@cmlinux10.ih.lucent.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/13 15:25, James Solner wrote:
> This patch adds the Documentation/module-signing.txt file that is
> currently missing from the Documentation directory. The init/Kconfig
> file references the Documentation/module-signing.txt file to explain
> how kernel module signing works. This patch supplies this documentation. 
> 
> The initial version of this patch provided old documentation
> that used that was a mix of the old RHEL style GPG signing. 
> This new version, version 1, is updated to the current appended-signature 
> x509 certificate signing. 
> 
> Signed-off-by: James Solner <solner@alcatel-lucent.com>
> 
> ---
>  Documentation/module-signing.txt | 117 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 117 insertions(+)
>  create mode 100644 Documentation/module-signing.txt
> 
> diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
> new file mode 100644
> index 0000000..fdae5b2
> --- /dev/null
> +++ b/Documentation/module-signing.txt
> @@ -0,0 +1,117 @@
> +		==============================
> +		KERNEL MODULE SIGNING FACILITY
> +		==============================
> +
> +The module signing facility applies cryptographic signature checking 
> +when loading modules by checking its signature against a public key. 
> +This allows increased kernel security by disallowing loading unsigned 
> +modules or modules signed with an invalid key. Module signing increases 
> +the kernel security and reduces the odds of malicious modules being 
> +loading into Linux operating system.
> +
> +This facility uses X.509 ITU-T standard to perform the cryptographic 
> +work and determines the format of the signatures and key data. The 

        and [to] determine

> +key type used is RSA and the possible hash algorithms that can be 
> +used  are SHA-1, SHA-224, SHA-256, SHA-384, and SHA-512. Provided 
> +the requisite algorithms are configured and compiled into the 

Provided.... is not a sentence.

> +kernel. The following hash algorithms can be selected during the kernel 
> +configuration build:
> +
> +	CONFIG_SIG_SHA1
> +	CONFIG_SIG_SHA224
> +	CONFIG_SIG_SHA256
> +	CONFIG_SIG_SHA384
> +	CONFIG_SIG_SHA512
> +	
> +The module signing facility is a kernel feature and is enabled through the 
> +Linux kernel configuration builder. In the "Enable Loadable Module Support"
> +section of the kernel configuration, the CONFIG_MODULE_SIG define is enabled 

                                                              symbol

> +to activate this feature. This feature supports two options for signed 
> +module support: "permissive" and "restrictive".  The default is the 
> +"permissive" option and allows a module with a valid signature to be loaded. 
> +If the signature is invalid, the module is still loaded, but the kernel is 
> +marked as "tainted". The "restrictive" option (CONFIG_MODULE_SIG_FORCE) 
> +requires a valid signature before the module can be loaded.
> +
> +There are two ways to signed modules: "automatically" or "manually". 

Missing some word after "to".

> +The CONFIG_MODULE_SIG_ALL define will automatically signed the modules 

                             symbol                    sign

> +during the "modules_install" part of the kernel build. A module can also 
> +be signed manually using the scripts/sign-file tool.
> +
> +================================================
> +AUTOMATICALLY GENERATING PUBLIC AND PUBLIC KEYS

Should one of these ^^^^^ be PRIVATE?

> +================================================
> +As part of "modules_install" kernel build, the Linux kernel build 
> +infrastructure will automatically create two files in the root node 
> +of the Linux kernel source tree. These files contain the public/private 
> +keys and are called "signing_key.x509" and "signing_key.priv". 
> +The public key is built into to the kernel and used to verify modules 

                                ^^drop "to"                      modules'

> +signatures when the modules are loaded. 
> +
> +=================================================
> +MANUALLY GENERATING PUBLIC AND PRIVATE KEYS
> +=================================================
> +To manually generate the key private/public files, use the x509.genkey key 
> +generation configuration file in the root mode of the Linux kernel 
> +sources tree and the openssl command. The following is an example to 

What does "in the root mode of the Linux kernel sources tree" mean?

Oh, I see later on that it is "root node".  Typo.

> +generate the public/private key files:
> +
> +	openssl req -new -nodes -utf8 -sha256 -days 36500 -batch -x509 \
> +	   -config x509.genkey -outform DER -out signing_key.x509 \
> +	   -keyout signing_key.priv
> +
> +=========================
> +MANUALLY SIGNING MODULES
> +=========================
> +To manually sign a module, use the scripts/sign-file tool available in 
> +the Linux kernel source tree. The script requires 4 arguments: 
> +
> +	1. The hash algorithm (e.g., sha256)
> +	2. The private key 
> +	3. The public key
> +	4. The kernel module to be signed
> +	
> +The following is an example to sign a kernel module: 
> +
> +	scripts/sign-file sha512 kernel-signkey.priv \
> +	    kernel-signkey.x509 module.ko
> +
> +============================
> +SIGNED MODULES AND STRIPPING
> +============================
> +
> +A signed modules has a digital signature appended at the end. The string 

            module

> +"~Module signature appended~." at the end of the module's file confirms 
> +that a signature is present. But, it does not confirm that the 
> +signature is valid!
> +
> +Signed modules are BRITTLE as the signature is outside of the defined
> +ELF container.  Thus they MAY NOT be stripped once the signature is computed
> +and attached. Note the entire module is the signed payload, including 
> +all the debug information present at the time of signing.
> +
> +======================
> +LOADING SIGNED MODULES
> +======================
> +
> +Modules are loaded with insmod, exactly as for unsigned modules.  
> +The signature checker checks at the end of the file for the signature 
> +marker and apply signature checking. 

              applies

> +
> +=========================================
> +NON-VALID SIGNATURES AND UNSIGNED MODULES
> +=========================================
> +
> +If CONFIG_MODULE_SIG_FORCE is enabled or enforcemodulesig=1 is supplied on
> +the kernel command line, the kernel will only load validly signed modules
> +for which it has a public key.  Otherwise, it will also load modules that are
> +unsigned.  Any module for which the kernel has a key, but which proves to have
> +a signature mismatch will not be permitted to load.
> +
> +=========================================
> +ADMINISTERING/PROTECTING THE PRIVATE KEY
> +=========================================
> +Since the private key is used to signed modules, malware can use 

                                    sign

> +the private key to signed modules and compromise the operating system. 

                      sign

> +The private key must be moved to secure location and not keep in 

                                 to a secure location and not kept in

> +the root node of the kernel source tree. 
> 


Finally, please strip all trailing spaces from each line (and there are many
of them).

-- 
~Randy
