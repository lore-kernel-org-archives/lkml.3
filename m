Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaCRAuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:50:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:8247 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbaCRAuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:50:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,673,1389772800"; 
   d="scan'208";a="500798178"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Sabrina Dubroka <sd@queasysnail.net>,
        Valdis Kletnieks <validis.kletnieks@vt.edu>
CC: Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>
Subject: RE: [RFC PATCH 1/2] ACPICA: Dispatcher: Ignore SyncLevel for
 auto-serialization mechanism.
Thread-Topic: [RFC PATCH 1/2] ACPICA: Dispatcher: Ignore SyncLevel for
 auto-serialization mechanism.
Thread-Index: AQHPQZeB599nwHkdH0iiv6M16UqddJrmBJfQ
Date: Tue, 18 Mar 2014 00:50:04 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024E1B17@SHSMSX101.ccr.corp.intel.com>
References: <14866.1394813101@turing-police.cc.vt.edu>
 <cover.1395028738.git.lv.zheng@intel.com>
 <bf7078d77da8d24ff11337673c6f0ea9442f294a.1395028738.git.lv.zheng@intel.com>
In-Reply-To: <bf7078d77da8d24ff11337673c6f0ea9442f294a.1395028738.git.lv.zheng@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Sabrina and Valdis

Could you give this patch a try to see if this patch is working?

Thanks and best regards
-Lv

> From: Zheng, Lv
> Sent: Monday, March 17, 2014 12:15 PM
> 
> From: Robert Moore <robert.moore@intel.com>
> 
> It is reported that the auto-serialization mechanism has broken some
> machine.  This patch fixes the issues by igoring the SyncLevel
> attribute of the marked Method.
> 
> References: http://www.spinics.net/lists/linux-acpi/msg49496.html
> Reported-by: Valdis Kletnieks <validis.kletnieks@vt.edu>
> Reported-by: Sabrina Dubroka <sd@queasysnail.net>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>  drivers/acpi/acpica/acobject.h |    3 ++-
>  drivers/acpi/acpica/dsmethod.c |   24 +++++++++++++++++++-----
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/acobject.h b/drivers/acpi/acpica/acobject.h
> index 1a4d618..22fb644 100644
> --- a/drivers/acpi/acpica/acobject.h
> +++ b/drivers/acpi/acpica/acobject.h
> @@ -193,7 +193,8 @@ struct acpi_object_method {
>  #define ACPI_METHOD_INTERNAL_ONLY       0x02	/* Method is implemented internally (_OSI) */
>  #define ACPI_METHOD_SERIALIZED          0x04	/* Method is serialized */
>  #define ACPI_METHOD_SERIALIZED_PENDING  0x08	/* Method is to be marked serialized */
> -#define ACPI_METHOD_MODIFIED_NAMESPACE  0x10	/* Method modified the namespace */
> +#define ACPI_METHOD_IGNORE_SYNC_LEVEL   0x10	/* Method was auto-serialized at table load time */
> +#define ACPI_METHOD_MODIFIED_NAMESPACE  0x20	/* Method modified the namespace */
> 
>  /******************************************************************************
>   *
> diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
> index 73764c7..3c7f737 100644
> --- a/drivers/acpi/acpica/dsmethod.c
> +++ b/drivers/acpi/acpica/dsmethod.c
> @@ -175,8 +175,15 @@ acpi_ds_detect_named_opcodes(struct acpi_walk_state *walk_state,
>  	 * At this point, we know we have a Named object opcode.
>  	 * Mark the method as serialized. Later code will create a mutex for
>  	 * this method to enforce serialization.
> +	 *
> +	 * Note, ACPI_METHOD_IGNORE_SYNC_LEVEL flag means that we will ignore the
> +	 * Sync Level mechanism for this method, even though it is now serialized.
> +	 * Otherwise, there can be conflicts with existing ASL code that actually
> +	 * uses sync levels.
>  	 */
> -	walk_state->method_desc->method.info_flags |= ACPI_METHOD_SERIALIZED;
> +	walk_state->method_desc->method.sync_level = 0;
> +	walk_state->method_desc->method.info_flags |=
> +	    (ACPI_METHOD_SERIALIZED | ACPI_METHOD_IGNORE_SYNC_LEVEL);
> 
>  	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
>  			  "Method serialized [%4.4s] %p - [%s] (%4.4X)\n",
> @@ -349,13 +356,19 @@ acpi_ds_begin_method_execution(struct acpi_namespace_node *method_node,
>  		/*
>  		 * The current_sync_level (per-thread) must be less than or equal to
>  		 * the sync level of the method. This mechanism provides some
> -		 * deadlock prevention
> +		 * deadlock prevention.
> +		 *
> +		 * If the method was auto-serialized, we just ignore the sync level
> +		 * mechanism, because auto-serialization of methods can interfere
> +		 * with ASL code that actually uses sync levels.
>  		 *
>  		 * Top-level method invocation has no walk state at this point
>  		 */
>  		if (walk_state &&
> -		    (walk_state->thread->current_sync_level >
> -		     obj_desc->method.mutex->mutex.sync_level)) {
> +		    (!(obj_desc->method.
> +		       info_flags & ACPI_METHOD_IGNORE_SYNC_LEVEL))
> +		    && (walk_state->thread->current_sync_level >
> +			obj_desc->method.mutex->mutex.sync_level)) {
>  			ACPI_ERROR((AE_INFO,
>  				    "Cannot acquire Mutex for method [%4.4s], current SyncLevel is too large (%u)",
>  				    acpi_ut_get_node_name(method_node),
> @@ -800,7 +813,8 @@ acpi_ds_terminate_control_method(union acpi_operand_object *method_desc,
>  			method_desc->method.info_flags &=
>  			    ~ACPI_METHOD_SERIALIZED_PENDING;
>  			method_desc->method.info_flags |=
> -			    ACPI_METHOD_SERIALIZED;
> +			    (ACPI_METHOD_SERIALIZED |
> +			     ACPI_METHOD_IGNORE_SYNC_LEVEL);
>  			method_desc->method.sync_level = 0;
>  		}
> 
> --
> 1.7.10

